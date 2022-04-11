import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // NOTE: For logging
      // let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      // print("==== didRegisterForRemoteNotificationsWithDeviceToken ====")
      // print(deviceTokenString)
      Messaging.messaging().apnsToken = deviceToken
    }
}

