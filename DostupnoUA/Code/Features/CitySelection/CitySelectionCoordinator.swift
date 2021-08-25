//
//  CitySelectionCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 24.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol CitySelectionCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator, _ cityId: String, _ cityName: String?) -> Void)? { get set }
    var didCancel: ((_ coordinator: Coordinator) -> Void)? { get set }
    var didClear: ((_ coordinator: Coordinator, _ cityId: String) -> Void)? { get set }
}

final class CitySelectionCoordinator: Coordinator, CitySelectionCoordinatorOutput {
    
    var didFinish: ((Coordinator, String, String?) -> Void)?
    var didClear: ((Coordinator, String) -> Void)?
    var didCancel: ((Coordinator) -> Void)?
        
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: CitySelectionModuleFactoryProtocol
    private let currentCityId: String?

    init(router: Router, moduleFactory: CitySelectionModuleFactoryProtocol, storageManager: StorageManagerProtocol, currentCityId: String?) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        self.currentCityId = currentCityId
        let router = router
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runCitySelection()
    }
    
    func runCitySelection(_ option: DeepLinkOption? = nil) {
        guard var module = moduleFactory.makeCitySelectionModule(cityId: currentCityId) else {
            return
        }
        module.nav.didFinish = { [weak self] cityId, cityName in
            if let self = self {
                self.didFinish?(self, cityId, cityName)
            }
        }
        module.nav.didClearSelection = { [weak self] cityId in
            if let self = self {
                self.didClear?(self, cityId)
            }
        }
        module.nav.didCancel = { [weak self] in
            if let self = self {
                self.didCancel?(self)
            }
        }
        router.push(module.viewController)
    }
}
