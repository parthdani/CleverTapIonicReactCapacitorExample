import UIKit
import Capacitor
import CleverTapSDK
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    var   type = UIUserNotificationType.badge.rawValue | UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue;
    UNUserNotificationCenter.current().delegate = self

    var setting = UIUserNotificationSettings(types: UIUserNotificationType(rawValue: type), categories: nil);
    UIApplication.shared.registerUserNotificationSettings(setting);
    UIApplication.shared.registerForRemoteNotifications();
    CleverTap.autoIntegrate()
    // Override point for customization after application launch.
    return true
  }
    
    
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        CleverTap.handlePushNotification(userInfo, openDeepLinksInForeground: true)
    }
    
  func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        CleverTap.sharedInstance()?.handleOpen(url as URL, sourceApplication: sourceApplication)
        return true
    }
    
    // This method will be called when app received push notifications in foreground
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    

 func open(_ url: URL, options: [String : Any] = [:],
              completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)
        completion?(false)
    }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
    
    

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Called when the app was launched with a url. Feel free to add additional processing here,
    // but if you want the App API to support tracking app url opens, make sure to keep this call
    return CAPBridge.handleOpenUrl(url, options)
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    // Called when the app was launched with an activity, including Universal Links.
    // Feel free to add additional processing here, but if you want the App API to support
    // tracking app url opens, make sure to keep this call
    return CAPBridge.handleContinueActivity(userActivity, restorationHandler)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    let statusBarRect = UIApplication.shared.statusBarFrame
    guard let touchPoint = event?.allTouches?.first?.location(in: self.window) else { return }

    if statusBarRect.contains(touchPoint) {
      NotificationCenter.default.post(CAPBridge.statusBarTappedNotification)
    }
  }

  #if USE_PUSH

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     CleverTap.sharedInstance()?.setPushToken(deviceToken)
    NotificationCenter.default.post(name: Notification.Name(CAPNotifications.DidRegisterForRemoteNotificationsWithDeviceToken.name()), object: deviceToken)
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    NotificationCenter.default.post(name: Notification.Name(CAPNotifications.DidFailToRegisterForRemoteNotificationsWithError.name()), object: error)
  }

#endif

}

