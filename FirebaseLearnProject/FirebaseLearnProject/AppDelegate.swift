//
//  AppDelegate.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/10/24.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")

        let deviceStringToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("deviceStringToken : \(deviceStringToken)")
        Messaging.messaging().apnsToken = deviceToken
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // foreground 상태인 경우 표시 방법
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.list, .banner, .sound, .badge]
    }

}

extension AppDelegate: MessagingDelegate {

    // 파이어베이스 MessagingDelegate 설정
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]

        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }

}
