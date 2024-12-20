import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'in_app_file_view_method_channel.dart';

abstract class InAppFileViewPlatform extends PlatformInterface {
  /// Constructs a InAppFileViewPlatform.
  InAppFileViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static InAppFileViewPlatform _instance = MethodChannelInAppFileView();

  /// The default instance of [InAppFileViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelInAppFileView].
  static InAppFileViewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InAppFileViewPlatform] when
  /// they register themselves.
  static set instance(InAppFileViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
