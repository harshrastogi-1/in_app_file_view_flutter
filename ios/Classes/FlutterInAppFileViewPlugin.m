#import "FlutterInAppFileViewPlugin.h"
#if __has_include(<in_app_file_view/in_app_file_view-Swift.h>)
#import <in_app_file_view/in_app_file_view-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "in_app_file_view-Swift.h"
#endif

@implementation FlutterInAppFileViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [InAppFileViewPlugin registerWithRegistrar:registrar];
}
@end
