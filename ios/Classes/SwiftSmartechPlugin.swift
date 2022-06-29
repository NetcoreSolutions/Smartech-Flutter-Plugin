import Flutter
import UIKit
import Smartech
protocol SwiftSmartechPluginDelegate:class {

}
public class SwiftSmartechPlugin: NSObject, FlutterPlugin {
    public static let sharedInstance = SwiftSmartechPlugin()
    static var channel: FlutterMethodChannel?
    public static  var openNativeWebView:(()->())?
    weak var delegate:SwiftSmartechPluginDelegate?
  public static func register(with registrar: FlutterPluginRegistrar) {
     channel = FlutterMethodChannel(name: "smartech_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftSmartechPlugin()

    registrar.addMethodCallDelegate(instance, channel: channel!)
  }
   public static func handleDeeplinkAction(withURLString deeplinkURLString: String, andCustomPayload customPayload: [AnyHashable : Any]?) {
        let dict = [
            "deeplinkURL" : deeplinkURLString,
            "customPayload":customPayload ?? [:],
            "isAfterTerminated":false
        ] as [String : Any]

    channel?.invokeMethod("onhandleDeeplinkAction", arguments: dict, result: { (value) in
        let userDefault = UserDefaults.standard
        guard let value = value else {
            userDefault.removeObject( forKey: "DeeplinkActionData")
            return
        }
        if (value is FlutterError) {
            userDefault.set(dict, forKey: "DeeplinkActionData")
            return
        }
        userDefault.set(dict,forKey: "DeeplinkActionData")
    })
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "getDevicePushToken":
        result(Smartech.sharedInstance().getDevicePushToken())
    case "getDeviceGuid":
        result(Smartech.sharedInstance().getDeviceGuid())

    case "updateUserProfile" :
        Smartech.sharedInstance().updateUserProfile(call.arguments as! Dictionary<AnyHashable, Any>)
        result(nil)
    case "setUserIdentity":
        Smartech.sharedInstance().setUserIdentity(call.arguments as! String)
        result(nil)
    case "getUserIdentity":
        result(Smartech.sharedInstance().getUserIdentity())

    case "login":
        Smartech.sharedInstance().login(call.arguments as! String)
        result(nil)
    case "clearUserIdentity":
        Smartech.sharedInstance().clearUserIdentity()
        result(nil)
    case "logoutAndClearUserIdentity":
        Smartech.sharedInstance().logoutAndClearUserIdentity(call.arguments as! Bool)
        result(nil)
    case "trackAppInstallUpdateBySmartech":
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        result(nil)
    case "trackAppInstall":
        Smartech.sharedInstance().trackAppInstall()
        result(nil)
    case "trackAppUpdate":
        Smartech.sharedInstance().trackAppUpdate()
        result(nil)
    case "trackEvent":
        trackEvent(call: call)
        result(nil)
    case "setUserLocation":
        setUserLocation(call: call)
        result(nil)
    case "processEventsManually":
        Smartech.sharedInstance().processEventsManually()
        result(nil)
    case "optTracking":
        Smartech.sharedInstance().optTracking(call.arguments as! Bool)
        result(nil)
    case "optInAppMessage":
        Smartech.sharedInstance().opt(inAppMessage: call.arguments as! Bool)
        result(nil)
    case "optPushNotification":
        Smartech.sharedInstance().optPushNotification(call.arguments as! Bool)
        result(nil)
    case "hasOptedTracking":
        result(Smartech.sharedInstance().hasOptedTracking())
    case "hasOptedPushNotification":
        result(Smartech.sharedInstance().hasOptedPushNotification())
    case "hasOptedInAppMessage":
        result(Smartech.sharedInstance().hasOptedInAppMessage())
    case "getDeviceUniqueId":
        result(Smartech.sharedInstance().getDeviceGuid())
    case "openNativeWebView":
        SwiftSmartechPlugin.openNativeWebView?()
        result(nil)
    case "onhandleDeeplinkActionBackground":
        let userDefault = UserDefaults.standard
        guard let dict = userDefault.dictionary(forKey: "DeeplinkActionData") else {
            return
        }
        var dictionary = dict;
        dictionary["isAfterTerminated"] = true
        SwiftSmartechPlugin.channel?.invokeMethod("onhandleDeeplinkAction", arguments: dict)
        userDefault.removeObject(forKey: "DeeplinkActionData")
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }

  }

    private func setUserLocation(call: FlutterMethodCall) {
        let dict = call.arguments as! Dictionary<String, Any>
        let location = CLLocationCoordinate2DMake(dict["latitude"] as! Double, dict["longitude"] as! Double)
        Smartech.sharedInstance().setUserLocation(location)

    }

    private func trackEvent(call: FlutterMethodCall) {
        let dict = call.arguments as! Dictionary<String, Any>
        Smartech.sharedInstance().trackEvent(dict["event_name"] as! String, andPayload: dict["event_data"] as? Dictionary<AnyHashable, Any>)
    }


}
