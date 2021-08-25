//
//  StartupCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

protocol StartupCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator, _ showLoginScreen: Bool) -> Void)? { get set }
}

final class StartupCoordinator: Coordinator, StartupCoordinatorOutput {
        
    private let moduleFactory: StartupModuleFactoryProtocol
    
    var didFinish: ((Coordinator, Bool) -> Void)?

    init(router: Router, moduleFactory: StartupModuleFactoryProtocol) {
        self.moduleFactory = moduleFactory
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runStartup()
    }
    
    func runStartup() {
        guard var startupModule = moduleFactory.makeStartupModule() else {
            return
        }
        startupModule.nav.onFinish = {  [weak self] showLoginScreen in
            if let self = self {
                self.didFinish?(self, showLoginScreen)
            }
        }

        router.setRootModule(startupModule.viewController, hideBar: true)
    }
}
