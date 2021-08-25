//
//  AppDelegate.swift
//  DostupnoUA
//
//  Created by admin on 9/4/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let navigationController = NavigationController()
    
    let configurator = ExternalLibraryConfigurator()
    let pushNotificationService = PushNotificationService()

    private lazy var applicationCoordinator: Coordinatable = {
        let coordinatorFactory = CoordinatorFactory()
        let storageManager = StorageManager.shared
        let router = Router(rootController: navigationController)
        return AppCoordinator(router: router,
                              coordinatorFactory: coordinatorFactory,
                              storageManager: storageManager)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Appearance.setup()
        let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
        let deepLink = DeepLinkOption.build(with: notification)
        PersistenceManager.manager.configure()
        applicationCoordinator.start(with: deepLink)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        configurator.setup(application, didFinishLaunchingWithOptions: launchOptions)
        pushNotificationService.registerForRemoteNotifications(application)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return configurator.application(app, open: url, options: options)
    }

    // MARK: Handle push notifications and deep links
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        pushNotificationService.setDeviceToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let dict = userInfo as? [String: AnyObject]
        let deepLink = DeepLinkOption.build(with: dict)
        applicationCoordinator.start(with: deepLink)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let deepLink = DeepLinkOption.build(with: userActivity)
        applicationCoordinator.start(with: deepLink)
        return true
    }
}
