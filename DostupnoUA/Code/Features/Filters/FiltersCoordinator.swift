//
//  FiltersCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol FiltersCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator) -> Void)? { get set }
    var didGetLocations: ((_ coordinator: Coordinator) -> Void)? { get set }
    var didCancel: ((_ coordinator: Coordinator) -> Void)? { get set }
}

final class FiltersCoordinator: Coordinator, FiltersCoordinatorOutput {
    
    var didCancel: ((Coordinator) -> Void)?
    var didFinish: ((Coordinator) -> Void)?
    var didGetLocations: ((Coordinator) -> Void)?
        
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: FiltersModuleFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol

    init(router: Router, moduleFactory: FiltersModuleFactoryProtocol, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        let router = router
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runMainFilters()
    }
    
    func runMainFilters(_ option: DeepLinkOption? = nil) {
        guard var module = moduleFactory.makeMainFiltersModule() else {
            return
        }
        module.nav.didFinish = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }
        module.nav.toGetLocations = { [weak self] in
            if let self = self {
                self.didGetLocations?(self)
            }
        }
        module.nav.toFilter = { [weak self] filterInfo in
            self?.runFilters(selectionInfo: filterInfo)
        }
        module.nav.toCitySelection = { [weak self] currentCityId in
            self?.runCitySelection(currentCityId: currentCityId,
                                   completion: { cityId, cityName in
                                    module.presenter.setCurrentCityId(cityId)
                                    module.presenter.updateCurrentCity(name: cityName)
            },
                                   clearCompletion: { _ in
                                    module.presenter.clearCurrentCity()
            })
        }
        router.push(module.viewController)
    }
    
    func runFilters(selectionInfo: FilterSelectionInfo) {
        guard var module = moduleFactory.makeFiltersModule(filterSelectionInfo: selectionInfo) else {
            return
        }
        module.nav.toFilter = { [weak self] filterInfo in
            self?.runFilters(selectionInfo: filterInfo)
        }
        module.nav.toGetLocations = { [weak self] in
            if let self = self {
                self.didGetLocations?(self)
            }
        }
        router.push(module.viewController)
    }
    
    func runCitySelection(currentCityId: String?,
                          completion: @escaping((_ cityID: String, _ cityName: String?) -> Void),
                          clearCompletion: @escaping((_ cityID: String) -> Void)) {
        var citySelectionCoordinator = coordinatorFactory.makeCitySelectionCoordinator(router: router, storageManager: storageManager, cityId: currentCityId)
        addDependency(citySelectionCoordinator)
        citySelectionCoordinator.start()
        
        citySelectionCoordinator.didFinish = { [weak self] coordinator, cityId, cityName in
            completion(cityId, cityName)
            self?.removeDependency(coordinator)
            self?.router.popModule(animated: true)
        }
        citySelectionCoordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popModule(animated: true)
        }
        
        citySelectionCoordinator.didClear = { [weak self] coordinator, cityId in
            clearCompletion(cityId)
            self?.removeDependency(coordinator)
            self?.router.popModule(animated: true)
        }
    }
}
