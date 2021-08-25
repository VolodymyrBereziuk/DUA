//
//  ScanCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

final class ScanCoordinator: Coordinator {
    
    private let storageManager: StorageManagerProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    init(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        
        self.storageManager = storageManager
        self.coordinatorFactory = coordinatorFactory
        let navigationVC = NavigationController()
        let router = Router(rootController: navigationVC)
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runScanner()
    }
    
    func runScanner() {
        let scanViewController = R.storyboard.scan.scanViewController() ?? UIViewController()
        router.setRootModule(scanViewController, hideBar: false)
    }
}
