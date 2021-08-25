//
//  MainTabBarCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

final class MainTabBarCoordinator: Coordinator {
    
    let scanCoordinator: Coordinator
    let mapCoordinator: Coordinator
    var profileCoordinator: Coordinator & UserProfileCoordinatorOutput
    
    private let storageManager: StorageManagerProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private var showLoginScreen = false
    var tabBarController: UITabBarController?
    
    init(router: Router, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol, showLoginScreen: Bool) {
        self.storageManager = storageManager
        self.coordinatorFactory = coordinatorFactory
        scanCoordinator = coordinatorFactory.makeScanCoordinator(storageManager: storageManager, coordinatorFactory: coordinatorFactory)
        mapCoordinator = coordinatorFactory.makeMapCoordinator(storageManager: storageManager, coordinatorFactory: coordinatorFactory)
        profileCoordinator = coordinatorFactory.makeProfileCoordinator(storageManager: storageManager, coordinatorFactory: coordinatorFactory)
        self.showLoginScreen = showLoginScreen
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runTabBarViewController()
    }
    
    func runTabBarViewController() {
        tabBarController = R.storyboard.mainTabBar.mainTabBarViewController()
        //tabBarController?.delegate = self
        router.setRootModule(tabBarController, hideBar: true)
        
        addDependency(scanCoordinator)
        addDependency(mapCoordinator)
        addDependency(profileCoordinator)
        
        scanCoordinator.start()
        mapCoordinator.start()
        profileCoordinator.start()
        
        guard let viewController1 = scanCoordinator.router.toPresent(),
            let viewController2 = mapCoordinator.router.toPresent(),
            let viewController3 = profileCoordinator.router.toPresent() else {
                return
        }
        
        profileCoordinator.onSuccessAuthentication = { [weak self, weak viewController2] _ in
            self?.tabBarController?.selectedViewController = viewController2
        }
        
        viewController1.tabBarItem = UITabBarItem(title: nil, image: R.image.mapScan(), selectedImage: nil)
        viewController2.tabBarItem = UITabBarItem(title: nil, image: R.image.map(), selectedImage: nil)
        viewController3.tabBarItem = UITabBarItem(title: nil, image: R.image.user(), selectedImage: nil)
        if let tabBarController = router.topmostPresented() as? UITabBarController {
            tabBarController.viewControllers = [viewController1, viewController2, viewController3]
            tabBarController.viewControllers?.forEach {
                $0.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            }
            tabBarController.selectedViewController = viewController2
            customise(tabBar: tabBarController.tabBar)
            tabBarController.setTabBar(isHidden: true)
        }
        tabBarController?.selectedViewController = showLoginScreen ? viewController3 : viewController2
    }
    
    func customise(tabBar: UITabBar) {
        tabBar.tintColor = R.color.ickyGreen()
    }
}
