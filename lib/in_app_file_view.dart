// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'in_app_file_view_platform_interface.dart';

export 'src/enum/view_status.dart';
export 'src/enum/x5_status.dart';
export 'src/file_view.dart';
export 'src/file_view_localizations.dart';
export 'src/flutter_file_view.dart';

class InAppFileView {
  Future<String?> getPlatformVersion() {
    return InAppFileViewPlatform.instance.getPlatformVersion();
  }
}
