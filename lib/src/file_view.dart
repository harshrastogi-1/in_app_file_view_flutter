import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/plugin_file_constants.dart';
import 'enum/view_status.dart';
import 'file_view_localizations.dart';
import 'flutter_file_view.dart';

/// @Describe: The view of file.

/// The view of file.
class FileView extends StatefulWidget {
  // ignore: public_member_api_docs
  const FileView({
    super.key,
    required this.controller,
    this.tipTextStyle,
    this.buttonTextStyle,
    this.progressColor,
    this.unSupportedFileTypeWidget,
    this.unSupportedPlatformWidget,
    this.nonExistentWidget,
  });

  /// The [FileViewController] responsible for the file being rendered in this
  /// widget.
  final FileViewController controller;

  /// The style of the text for the prompt.
  final TextStyle? tipTextStyle;

  /// The style of the text for button.
  final TextStyle? buttonTextStyle;

  /// The color of the progress while loading.
  final Color? progressColor;

  /// Widget to display when the platform is unsupported.
  /// This widget is shown as a fallback when the application
  /// encounters an unsupported platform scenario.
  final Widget? unSupportedPlatformWidget;

  /// Widget to display when the file type is unsupported.
  /// This widget is used to inform the user that the provided
  /// file type cannot be handled by the application.
  final Widget? unSupportedFileTypeWidget;

  /// Widget to display when the requested resource does not exist.
  /// This widget is shown when the application fails to find
  /// the specified file, resource, or content.
  final Widget? nonExistentWidget;

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  late FileViewLocalizations local = FileViewLocalizations.of(context);

  @override
  void initState() {
    controller.initialize();
    controller.addListener(_listener);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant FileView oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.removeListener(_listener);
    controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();
    controller.removeListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (value.viewStatus == ViewStatus.done) {
      return _buildDoneWidget();
    }
    if (value.viewStatus == ViewStatus.unsupportedPlatform) {
      return widget.unSupportedPlatformWidget ??
          _buildUnSupportPlatformWidget();
    } else if (value.viewStatus == ViewStatus.nonExistent) {
      return widget.nonExistentWidget ?? _buildNonExistentWidget();
    } else if (value.viewStatus == ViewStatus.unsupportedFileType) {
      return widget.unSupportedFileTypeWidget ?? _buildUnSupportTypeWidget();
    } else {
      return _buildPlaceholderWidget();
    }
  }

  /// The layout to display when the platform is unsupported.
  ///
  /// This prompt is required because it only supports  iOS,
  /// and has not been adapted to desktop and web for the time being.
  Widget _buildUnSupportPlatformWidget() {
    return showTipWidget(local.unSupportedPlatformTip);
  }

  /// The layout to display when the file does not exist.
  Widget _buildNonExistentWidget() {
    return showTipWidget(local.nonExistentTip);
  }

  /// The layout to display when the file type is unsupported.
  Widget _buildUnSupportTypeWidget() {
    return showTipWidget(sprintf(local.unSupportedType, value.fileType ?? ''));
  }

  /// Widgets for presenting information
  Widget showTipWidget(String tip) {
    return Center(child: Text(tip, style: widget.tipTextStyle));
  }

  /// The layout to display when complete.
  Widget _buildDoneWidget() {
    if (isIOS) {
      return Stack(
        children: <Widget>[
          UiKitView(
            viewType: viewName,
            creationParams: <String, String>{
              'filePath': value.filePath ?? '',
              'fileType': value.fileType ?? '',
            },
            creationParamsCodec: const StandardMessageCodec(),
          ),
          if ((value.progressForIOS ?? 0) < 100) _buildPlaceholderWidget(),
        ],
      );
    }

    return _buildUnSupportPlatformWidget();
  }

  /// The layout to display when loading.
  Widget _buildPlaceholderWidget() {
    return Center(
      child: CircularProgressIndicator(
        key: ValueKey<String>('FileView_${hashCode}_Placeholder'),
        value: value.progressValue,
        color: widget.progressColor,
      ),
    );
  }

  /// A replacement operation for [stringTf].
  String sprintf(String stringTf, String msg) {
    return stringTf.replaceAll('%s', msg);
  }

  FileViewController get controller => widget.controller;

  FileViewValue get value => controller.value;
}

/// According to [status], display different layouts.
///
/// In state [ViewStatus.DONE], the layout cannot be customized.
typedef OnCustomViewStatusBuilder = Widget? Function(
  BuildContext context,
  ViewStatus status,
);
