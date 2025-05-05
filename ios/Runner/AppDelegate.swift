// import UIKit
// import Flutter
// import Firebase
// import FirebaseMessaging

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     FirebaseMessaging.messaging().delegate = self

//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?

  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Set the UNUserNotificationCenter delegate
    UNUserNotificationCenter.current().delegate = self

    // Request notification permissions
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )

    application.registerForRemoteNotifications()
    Messaging.messaging().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle received remote notifications
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)

    completionHandler(UIBackgroundFetchResult.newData)
  }

  // Messaging delegate method to receive the current FCM token
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    // Optionally, send the token to your server or use it in some way
  }

  // Handle notifications for iOS 10 and later
  @available(iOS 10.0, *)
 override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  @available(iOS 10.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)

    completionHandler()
  }


/// image notification
    @available(iOS 10.0, *)
  private func handleNotification(with userInfo: [AnyHashable: Any], completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    guard let imageUrlString = userInfo["image"] as? String, let imageUrl = URL(string: imageUrlString) else {
      // If there's no image URL, show the notification as usual
      completionHandler([[.alert, .sound]])
      return
    }

    downloadImage(from: imageUrl) { image in
      if let image = image, let attachment = self.saveImageAttachment(image: image) {
        // Create a mutable notification content
        let content = UNMutableNotificationContent()
        content.title = userInfo["title"] as? String ?? ""
        content.body = userInfo["body"] as? String ?? ""
        content.sound = .default
        content.attachments = [attachment]

        // Show the notification with the image attachment
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        completionHandler([])
      } else {
        // If the image could not be downloaded, show the notification as usual
        completionHandler([[.alert, .sound]])
      }
    }
  }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data, let image = UIImage(data: data) {
        completion(image)
      } else {
        completion(nil)
      }
    }
    task.resume()
  }

  private func saveImageAttachment(image: UIImage) -> UNNotificationAttachment? {
    let directory = NSTemporaryDirectory()
    let imagePath = directory + "/notification_image.jpg"
    let imageUrl = URL(fileURLWithPath: imagePath)

    do {
      try image.jpegData(compressionQuality: 1.0)?.write(to: imageUrl)
      let attachment = try UNNotificationAttachment(identifier: UUID().uuidString, url: imageUrl, options: nil)
      return attachment
    } catch {
      print("Error saving image attachment: \(error)")
      return nil
    }
  }
}


// import UIKit
// import Flutter
// import Firebase
// import FirebaseMessaging
// import UserNotifications

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(withRegistry: self)
//     UNUserNotificationCenter.current().delegate = self
//     let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//     UNUserNotificationCenter.current().requestAuthorization(
//       options: authOptions,
//       completionHandler: { granted, error in
//         // Handle granted or error
//       }
//     )

//     application.registerForRemoteNotifications()
//     Messaging.messaging().delegate = self

//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//     if let messageID = userInfo["gcm.message_id"] {
//       print("Message ID: \(messageID)")
//     }
//     print(userInfo)

//     completionHandler(UIBackgroundFetchResult.newData)
//   }

//   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//     print("Firebase registration token: \(String(describing: fcmToken))")

//     let dataDict: [String: String] = ["token": fcmToken ?? ""]
//     NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//   }

//   @available(iOS 10.0, *)
//   override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//     let userInfo = notification.request.content.userInfo

//     if let messageID = userInfo["gcm.message_id"] {
//       print("Message ID: \(messageID)")
//     }
//     print(userInfo)

//     completionHandler([[.alert, .sound]])
//   }

//   @available(iOS 10.0, *)
//   override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//     let userInfo = response.notification.request.content.userInfo

//     if let messageID = userInfo["gcm.message_id"] {
//       print("Message ID: \(messageID)")
//     }
//     print(userInfo)

//     completionHandler()
//   }

//   @available(iOS 10.0, *)
//   private func handleNotification(with userInfo: [AnyHashable: Any], completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//     guard let imageUrlString = userInfo["image"] as? String, let imageUrl = URL(string: imageUrlString) else {
//       // If there's no image URL, show the notification as usual
//       completionHandler([[.alert, .sound]])
//       return
//     }

//     downloadImage(from: imageUrl) { image in
//       if let image = image, let attachment = self.saveImageAttachment(image: image) {
//         // Create a mutable notification content
//         let content = UNMutableNotificationContent()
//         content.title = userInfo["title"] as? String ?? ""
//         content.body = userInfo["body"] as? String ?? ""
//         content.sound = .default
//         content.attachments = [attachment]

//         // Show the notification with the image attachment
//         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
//         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//         completionHandler([])
//       } else {
//         // If the image could not be downloaded, show the notification as usual
//         completionHandler([[.alert, .sound]])
//       }
//     }
//   }

//   private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
//     let task = URLSession.shared.dataTask(with: url) { data, response, error in
//       if let data = data, let image = UIImage(data: data) {
//         completion(image)
//       } else {
//         completion(nil)
//       }
//     }
//     task.resume()
//   }

//   private func saveImageAttachment(image: UIImage) -> UNNotificationAttachment? {
//     let directory = NSTemporaryDirectory()
//     let imagePath = directory + "/notification_image.jpg"
//     let imageUrl = URL(fileURLWithPath: imagePath)

//     do {
//       try image.jpegData(compressionQuality: 1.0)?.write(to: imageUrl)
//       let attachment = try UNNotificationAttachment(identifier: UUID().uuidString, url: imageUrl, options: nil)
//       return attachment
//     } catch {
//       print("Error saving image attachment: \(error)")
//       return nil
//     }
//   }
// }
