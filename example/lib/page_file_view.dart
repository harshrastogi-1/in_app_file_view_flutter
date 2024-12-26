import 'package:flutter/material.dart';
import 'package:in_app_file_view/in_app_file_view.dart';

class FileViewPage extends StatefulWidget {
  const FileViewPage({super.key, required this.controller});

  /// The [FileViewController] responsible for the file being rendered in this
  /// widget.
  final FileViewController controller;

  @override
  State<FileViewPage> createState() => _FileViewPageState();
}

class _FileViewPageState extends State<FileViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: FileView(
              controller: widget.controller,
              progressColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
