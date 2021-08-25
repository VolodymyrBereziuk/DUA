//
//  LocationProcessCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol LocationProcessCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator) -> Void)? { get set }
//    var didCancel: ((_ coordinator: Coordinator) -> Void)? { get set }
}

final class LocationProcessCoordinator: Coordinator, LocationProcessCoordinatorOutput {
        
    var didCancel: ((Coordinator) -> Void)?
    var didFinish: ((Coordinator) -> Void)?
    
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: LocationProcessModuleFactory
    
    init(router: Router, moduleFactory: LocationProcessModuleFactory, storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runCreationIntro()
    }
    
    func runCreationIntro() {
        var module = moduleFactory.makeCreationIntroModule()
        
        module?.nav.didClose = { [weak self] in
            guard let self = self else { return }
            self.didFinish?(self)
        }
        
        module?.nav.didNext = { [weak self] in
            self?.showNext()
        }
        
        router.push(module?.viewController)
    }
    
    func showNext() {
        
    }
}
