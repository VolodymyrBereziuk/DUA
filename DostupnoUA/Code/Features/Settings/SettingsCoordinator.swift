//
//  SettingsCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol SettingsCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator) -> Void)? { get set }
    var didCancel: ((_ coordinator: Coordinator) -> Void)? { get set }
}

final class SettingsCoordinator: Coordinator, SettingsCoordinatorOutput {
    var didFinish: ((Coordinator) -> Void)?
    var didCancel: ((Coordinator) -> Void)?
    
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: SettingsModuleFactoryProtocol
    
    init(router: Router, storageManager: StorageManagerProtocol, moduleFactory: SettingsModuleFactoryProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        let router = router
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runSettings(option)
    }
    
    func runSettings(_ option: DeepLinkOption? = nil) {
        guard var module = moduleFactory.makeSettingsModule() else {
            return
        }
        module.nav.didFinish = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }
        
        module.nav.toLocalisation = { [weak self] in
            self?.runLocalisation()
        }
        router.push(module.viewController)
    }
    
    func runLocalisation() {
        guard let module = moduleFactory.makeLanguagesModule() else {
            return
        }
        router.push(module.viewController)
    }
}
