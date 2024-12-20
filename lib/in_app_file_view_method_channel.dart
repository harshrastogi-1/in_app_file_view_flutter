import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'in_app_file_view_platform_interface.dart';

/// An implementation of [InAppFileViewPlatform] that uses method channels.
class MethodChannelInAppFileView extends InAppFileViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('in_app_file_view');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
