//
//  MapCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

final class MapCoordinator: Coordinator {
        
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: MapModuleFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    var getLocations: (() -> Void)?

    init(moduleFactory: MapModuleFactoryProtocol, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        let navigationVC = NavigationController()
        let router = Router(rootController: navigationVC)
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runMap()
    }
    
    func runMap(_ option: DeepLinkOption? = nil) {
        guard var mapModule = moduleFactory.makeMapModule() else {
            return
        }
        mapModule.nav.toFiltersList = { [weak self] in
            self?.showFiltersList()
        }
        mapModule.nav.toLocationList = { [weak self] searchText, locationsResponse in
            self?.showLocationsList(searchText: searchText, locationsResponse: locationsResponse)
        }
        mapModule.nav.toLocationDetails = { [weak self] location in
            self?.showLocationDetails(location: location)
        }
        mapModule.nav.toCreateLocation = { [weak self] in
            self?.showCreateLocation()
        }
        let mapPresenter = mapModule.presenter
        getLocations = { [weak mapPresenter] in
            mapPresenter?.getLocations(coordinateBounds: nil, searchText: nil, onlyCoordinateResults: false)
        }
        
        router.setRootModule(mapModule.viewController, hideBar: false)
    }
    
    func showFiltersList() {
        var coordinator = coordinatorFactory.makeFiltersCoordinator(router: router, storageManager: storageManager, coordinatorFactory: coordinatorFactory)
        addDependency(coordinator)
        coordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popModule()
        }
        coordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popToRootModule(animated: true)
        }
        coordinator.didGetLocations = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popToRootModule(animated: true)
            self?.getLocations?()            
        }
        coordinator.start()
    }
    
    func showLocationsList(searchText: String?, locationsResponse: LocationsResponse) {
        var coordinator = coordinatorFactory.makeLocationsCoordinator(router: router, storageManager: storageManager)
        coordinator.didGetMapInfo = {
            return (searchText, locationsResponse)
        }
        addDependency(coordinator)
        coordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popModule()
        }
        coordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popToRootModule(animated: true)
        }
        coordinator.start()
    }
    
    func showLocationDetails(location: Location?) {
        var coordinator = coordinatorFactory.makeLocationsCoordinator(router: router, storageManager: storageManager)
        coordinator.didShowLocationDetails = {
            return (location)
        }
        addDependency(coordinator)
        coordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popModule()
        }
        coordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popToRootModule(animated: true)
        }

//        coordinator.start()
        if let coo = coordinator as? LocationsCoordinator {
            coo.runLocationDetails(location: nil)
        }
    }
    
    func showCreateLocation() {
        var coordinator = coordinatorFactory.makeLocationProcessCoordinator(router: router, storageManager: storageManager)
        addDependency(coordinator)
        coordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popToRootModule(animated: true)
        }
        coordinator.start()
    }
}
