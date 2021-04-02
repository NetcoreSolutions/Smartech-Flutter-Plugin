import UIKit
import Flutter
import Smartech
import smartech_flutter_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,SmartechDelegate{
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
    Smartech.sharedInstance().setDebugLevel(.debug)
    Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
    
    Smartech.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
    UNUserNotificationCenter.current().delegate = self
    
    
    
    SwiftSmartechPlugin.openNativeWebView = {
        if #available(iOS 11.0, *) {
            let viewController = UIApplication.shared.windows.first!.rootViewController as? FlutterViewController
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                if let webVc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController {
                    viewController?.present(webVc, animated: true, completion: nil)
                }
            } else {
                if let webVc =  storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController{
                    viewController?.present(webVc, animated: true, completion: nil)
                }
            }
        }
       
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Smartech.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    
    

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      Smartech.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    //MARK:- UNUserNotificationCenterDelegate Methods
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      Smartech.sharedInstance().willPresentForegroundNotification(notification)
      completionHandler([.alert, .badge, .sound])
    }
        
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      Smartech.sharedInstance().didReceive(response)
      completionHandler()
    }
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andCustomPayload customPayload: [AnyHashable : Any]?) {
        SwiftSmartechPlugin.handleDeeplinkAction(withURLString: deeplinkURLString, andCustomPayload: customPayload)
        }
}
