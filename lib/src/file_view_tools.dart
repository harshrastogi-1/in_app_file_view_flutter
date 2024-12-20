import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'constants/plugin_file_constants.dart';
import 'flutter_file_view.dart';

/// Utility class for file-related operations.
class FileViewTools {
  /// Retrieves the storage path for files.
  static Future<String> getDirectoryPath() async {
    final String directoryPath =
        '${(await FlutterFileView.getTemporaryDirectory()).path}/$cacheKey/';

    // Check if the folder exists, and create it if it does not.
    await Directory(directoryPath).create(recursive: true);

    return directoryPath;
  }

  /// Generates a key for saving the file based on its path and optional name.
  static String getFileSaveKey(String filePath, {String? fileName}) {
    return '${fileName ?? base64.encode(utf8.encode(getFileName(filePath)))}'
        '.'
        '${getFileType(filePath)}';
  }

  /// Extracts the name of the file from its path.
  static String getFileName(String filePath) {
    if (filePath.isEmpty) {
      return '';
    }

    final int index = filePath.lastIndexOf('/');
    return index <= -1 ? '' : filePath.substring(index + 1);
  }

  /// Extracts the file extension from its path.
  static String getFileType(String filePath) {
    if (filePath.isEmpty) {
      return '';
    }

    final int index = filePath.lastIndexOf('.');
    return index <= -1 ? '' : filePath.substring(index + 1);
  }

  /// Checks if a file exists at the given path.
  static bool fileExists(String filePath) => File(filePath).existsSync();

  /// Verifies if a file is supported based on its path.
  static bool isSupportByPath(String filePath) =>
      isSupportByType(getFileType(filePath));

  /// Verifies if a file is supported based on its type.
  static bool isSupportByType(String fileType) {
    final RegExp regExp = RegExp(r'(doc(?:|x)|xls(?:|x)|ppt(?:|x)|pdf|txt)$');
    return regExp.hasMatch(fileType.toLowerCase());
  }

  /// Downloads a file from a given URL to a specified path.
  static Future<bool> downloadFile(
    String fileUrl,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    NetworkConfig? config,
  }) async {
    // If the file already exists, skip the download.
    if (fileExists(savePath)) {
      return true;
    }

    try {
      final Dio dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(milliseconds: 90 * 1000),
          receiveTimeout: const Duration(milliseconds: 90 * 1000),
        ),
      );

      final Response<dynamic> response = await dio.download(
        fileUrl,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: config?.queryParameters,
        cancelToken: config?.cancelToken,
        deleteOnError: config?.deleteOnError ?? true,
        lengthHeader: config?.lengthHeader ?? Headers.contentLengthHeader,
        data: config?.data,
        options: config?.options,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
