import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_file_view/in_app_file_view.dart';
import 'package:in_app_file_view/in_app_file_view_method_channel.dart';
import 'package:in_app_file_view/in_app_file_view_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInAppFileViewPlatform
    with MockPlatformInterfaceMixin
    implements InAppFileViewPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void init({bool canDownloadWithoutWifi = true, bool canOpenDex2Oat = true}) {
    // TODO: implement init
  }
}

void main() {
  final InAppFileViewPlatform initialPlatform = InAppFileViewPlatform.instance;

  test('$MethodChannelInAppFileView is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInAppFileView>());
  });

  test('getPlatformVersion', () async {
    InAppFileView inAppFileViewPlugin = InAppFileView();
    MockInAppFileViewPlatform fakePlatform = MockInAppFileViewPlatform();
    InAppFileViewPlatform.instance = fakePlatform;

    expect(await inAppFileViewPlugin.getPlatformVersion(), '42');
  });
}
