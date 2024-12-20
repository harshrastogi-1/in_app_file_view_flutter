import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_file_view/src/constants/plugin_file_constants.dart';

import 'in_app_file_view_platform_interface.dart';

/// An implementation of [InAppFileViewPlatform] that uses method channels.
class MethodChannelInAppFileView extends InAppFileViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(channelName);

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  void init({
    bool canDownloadWithoutWifi = true,
    bool canOpenDex2Oat = true,
  }) {
    if (isAndroid) {
      methodChannel.invokeMethod<void>('init', <String, bool>{
        'canDownloadWithoutWifi': canDownloadWithoutWifi,
        'canOpenDex2Oat': canOpenDex2Oat,
      });
    }
  }
}
