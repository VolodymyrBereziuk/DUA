//
//  PushNotificationService.swift
//  DostupnoUA
//
//  Created by Anton on 20.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseMessaging

class PushNotificationService: NSObject {
    
    func registerForRemoteNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in })
        
        application.registerForRemoteNotifications()
    }
    
//    func setDeviceToken(deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
    
}

extension PushNotificationService: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) { }
}
