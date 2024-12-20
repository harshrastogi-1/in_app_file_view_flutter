import 'package:flutter/foundation.dart';

const String packageName = 'flutter_file_view';

/// Directory name to use for file caching.
const String cacheKey = 'libCacheFileData';

/// The name of the channel used by the plugin.
const String channelName = 'in_app_file_view.io.channel/method';

/// The name of the view used by the plugin.
const String viewName = 'in_app_file_view.io.view/local';

/// Whether the operating system is a version of
/// [Android](https://en.wikipedia.org/wiki/Android_%28operating_system%29).
bool isAndroid = defaultTargetPlatform == TargetPlatform.android;

/// Whether the operating system is a version of
/// [iOS](https://en.wikipedia.org/wiki/IOS).
bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
