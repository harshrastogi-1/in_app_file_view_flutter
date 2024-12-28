import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/plugin_file_constants.dart';
import 'enum/view_status.dart';
import 'file_view.dart';
import 'file_view_tools.dart';

class FlutterFileView {
  static const MethodChannel _channel = MethodChannel(channelName);

  /// iOS due to its WKWebView

  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files.
  ///
  /// Files in this directory may be cleared at any time. This does *not* return
  /// a new temporary directory. Instead, the caller is responsible for creating
  /// (and cleaning up) files or directories within this directory. This
  /// directory is scoped to the calling application.
  ///
  /// On iOS, this uses the `NSCachesDirectory` API.
  ///
  ///
  /// Throws a `MissingPlatformDirectoryException` if the system is unable to
  /// provide the directory.
  static Future<Directory> getTemporaryDirectory() async {
    final String? path = await _channel.invokeMethod('getTemporaryPath');

    if (path == null) {
      throw MissingPlatformDirectoryException(
        'Unable to get temporary directory',
      );
    }
    return Directory(path);
  }
}

/// The controller of [FileView].
///
/// The document is displayed in a Flutter app by creating a [FileView] widget.
///
/// To reclaim the resources used by the player call [dispose].
///
/// After [dispose] all further calls are ignored.
class FileViewController extends ValueNotifier<FileViewValue> {
  /// Constructs a [FileViewController] preview a document from an asset.
  ///
  /// The name of the asset is given by the [dataSource] argument and must not
  /// be null. The [package] argument must be non-null when the asset comes
  /// from a package and null otherwise.
  FileViewController.asset(
    this.dataSource, {
    this.package,
    this.customSavedFileName,
    this.isDelExist = true,
  })  : dataSourceType = DataSourceType.asset,
        networkConfig = null,
        super(FileViewValue.uninitialized());

  /// Constructs a [FileViewController] preview a document from obtained from
  /// the network.
  ///
  /// The URI for the document is given by the [dataSource] argument and must
  /// not be null.
  FileViewController.network(
    this.dataSource, {
    this.customSavedFileName,
    NetworkConfig? config,
    this.isDelExist = true,
  })  : dataSourceType = DataSourceType.network,
        package = null,
        networkConfig = config ?? NetworkConfig(),
        super(FileViewValue.uninitialized());

  /// Constructs a [FileViewController] preview a document from a file.
  FileViewController.file(
    File file, {
    this.customSavedFileName,
    this.isDelExist = true,
  })  : dataSource = file.path,
        dataSourceType = DataSourceType.file,
        package = null,
        networkConfig = null,
        super(FileViewValue.uninitialized());

  /// The URI to the document file. This will be in different formats depending
  /// on the [DataSourceType] of the original document.
  final String dataSource;

  /// Describes the type of data source this [FileViewController]
  /// is constructed with.
  final DataSourceType dataSourceType;

  /// Only set for [FileViewController.asset] documents. The package that the
  /// asset was loaded from.
  final String? package;

  /// The name used to generate the key to obtain the asset. For local assets
  /// this is [dataSource], and for assets from packages the [dataSource] is
  /// prefixed 'packages/<package_name>/'.
  String get keyName =>
      package == null ? dataSource : 'packages/$package/$dataSource';

  /// Define the name of the file to be stored in the cache yourself.
  final String? customSavedFileName;

  /// HTTP headers used for the request to the [dataSource].
  /// Only for [FileViewController.network].
  /// Always empty for other document types.
  final NetworkConfig? networkConfig;

  /// Whether to delete files with the same path.
  final bool isDelExist;

  /// Attempts to open the given [dataSource] and load metadata about
  /// the document.
  Future<void> initialize() async {
    if (!(isIOS)) {
      value = value.copyWith(viewStatus: ViewStatus.unsupportedPlatform);
      return;
    }

    FlutterFileView._channel.setMethodCallHandler(_handler);

    value = value.copyWith(viewStatus: ViewStatus.loading);

    /// The name of the file.
    final String fileName =
        FileViewTools.getFileSaveKey(dataSource, fileName: customSavedFileName);

    /// The storage address of the file.
    final String filePath =
        '${await FileViewTools.getDirectoryPath()}$fileName';

    final String fileType = FileViewTools.getFileType(filePath);
    value = value.copyWith(fileType: fileType);

    if (FileViewTools.isSupportByType(fileType)) {
      value = value.copyWith(filePath: filePath);

      /// The file to be used later.
      File? file;

      /// If the file itself exists, it will be deleted.
      if (isDelExist && FileViewTools.fileExists(filePath)) {
        await File(filePath).delete();
      }

      if (dataSourceType == DataSourceType.network) {
        final bool flag = await FileViewTools.downloadFile(
          dataSource,
          filePath,
          onReceiveProgress: (int count, int total) {
            value = value.copyWith(progressValue: count / total);
          },
          config: networkConfig,
        );

        if (flag) {
          file = File(filePath);
        }
      } else {
        try {
          file = File(filePath)..createSync(recursive: true);

          if (dataSourceType == DataSourceType.asset) {
            final ByteData bd = await rootBundle.load(keyName);
            await file.writeAsBytes(bd.buffer.asUint8List());
          } else if (dataSourceType == DataSourceType.file) {
            await file.writeAsBytes(File(dataSource).readAsBytesSync());
          }
        } catch (e) {
          file = null;
        }
      }

      if (file != null && FileViewTools.fileExists(filePath)) {
        value = value.copyWith(viewStatus: ViewStatus.done);
        if (isIOS) {
          await initializeForIOS();
        }
      } else {
        value = value.copyWith(viewStatus: ViewStatus.nonExistent);
      }
    } else {
      value = value.copyWith(viewStatus: ViewStatus.unsupportedFileType);
    }
  }

  /// Monitor the progress of the iOS loading.
  StreamController<num>? _progressController;

  /// Monitor the progress of the iOS loading.
  StreamSubscription<num>? _progressListener;

  /// Used to monitor the progress of iOS loading.
  Future<void> initializeForIOS() async {
    _progressController ??= StreamController<num>.broadcast();

    _progressListener = _progressController?.stream.listen((val) {
      value = value.copyWith(progressForIOS: val);
    });
  }

  /// Delete Files.
  void deleteFile() {
    final File file = File(value.filePath ?? '');

    if (isDelExist && file.existsSync()) {
      file.deleteSync();
    }
  }

  Future<void> _handler(MethodCall call) async {
    switch (call.method) {
      case 'onProgress':
        _progressController?.add(num.tryParse(call.arguments.toString()) ?? 0);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    deleteFile();
    _progressController?.close();
    _progressListener?.cancel();
    super.dispose();
  }
}

/// The viewStatus, filePath, fileType, downloadProgress,
/// [FileViewController].
class FileViewValue {
  /// Constructs a file with the given values. Only [viewStatus] is required.
  /// The rest will initialize with default values when unset.
  FileViewValue({
    required this.viewStatus,
    this.filePath,
    this.fileType,
    this.progressValue,
    this.progressForIOS,
  });

  /// Returns an instance for a file that hasn't been loaded.
  FileViewValue.uninitialized() : this(viewStatus: ViewStatus.none);

  /// The loaded state of the view.
  final ViewStatus viewStatus;

  /// The path where the file is stored.
  final String? filePath;

  /// The type of storage of the file
  final String? fileType;

  /// The progress of the loading of [CircularProgressIndicator].
  final double? progressValue;

  /// Invoked when a page is loading.
  final num? progressForIOS;

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWith].
  FileViewValue copyWith({
    ViewStatus? viewStatus,
    String? filePath,
    String? fileType,
    double? progressValue,
    num? progressForIOS,
  }) {
    return FileViewValue(
      viewStatus: viewStatus ?? this.viewStatus,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      progressValue: progressValue,
      progressForIOS: progressForIOS,
    );
  }
}

/// The way in which the document was originally loaded.
///
/// This has nothing to do with the document's file type. It's just the place
/// from which the document is fetched from.
enum DataSourceType {
  /// The document was included in the app's asset files.
  asset,

  /// The document was downloaded from the internet.
  network,

  /// The document was loaded off of the local filesystem.
  file,
}

/// HTTP headers used for the request to the `dataSource`.
/// Only for [FileViewController.network].
/// Always empty for other document types.
class NetworkConfig {
  // ignore: public_member_api_docs
  NetworkConfig({
    this.queryParameters,
    this.cancelToken,
    this.deleteOnError,
    this.lengthHeader,
    this.data,
    this.options,
  });

  /// [Dio.download] `queryParameters`
  final Map<String, dynamic>? queryParameters;

  /// [Dio.download] `cancelToken`
  final CancelToken? cancelToken;

  /// [Dio.download] `deleteOnError`
  final bool? deleteOnError;

  /// [Dio.download] `lengthHeader`
  final String? lengthHeader;

  /// [Dio.download] `data`
  final dynamic data;

  /// [Dio.download] `options`
  final Options? options;
}

/// An exception thrown when a directory that should always be available on
/// the current platform cannot be obtained.
class MissingPlatformDirectoryException implements Exception {
  /// Creates a new exception
  MissingPlatformDirectoryException(this.message, {this.details});

  /// The explanation of the exception.
  final String message;

  /// Added details, if any.
  ///
  /// E.g., an error object from the platform implementation.
  final Object? details;

  @override
  String toString() {
    final String detailsAddition = details == null ? '' : ': $details';
    return 'MissingPlatformDirectoryException($message)$detailsAddition';
  }
}
