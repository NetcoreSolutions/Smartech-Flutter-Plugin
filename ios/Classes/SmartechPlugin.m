#import "SmartechPlugin.h"
#if __has_include(<smartech_flutter_plugin/smartech_flutter_plugin-Swift.h>)
#import <smartech_flutter_plugin/smartech_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "smartech_flutter_plugin-Swift.h"
#endif

@implementation SmartechPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmartechPlugin registerWithRegistrar:registrar];
}
@end
