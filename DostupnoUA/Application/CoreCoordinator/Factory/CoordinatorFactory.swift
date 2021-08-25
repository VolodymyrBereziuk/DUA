//
//  CoordinatorFactory.swift
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makePopupCoordinator(router: Router, storageManager: StorageManagerProtocol, popupType: PopupType) -> Coordinator & PopupCoordinatorOutput {
        let moduleFactory = PopupModuleFactory(storageManager: storageManager)
        return PopupCoordinator(router: router, storageManager: storageManager, moduleFactory: moduleFactory, popupType: popupType)
    }
    
    func makeMainTabBarCoordinator(router: Router, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol, showLoginScreen: Bool) -> Coordinator {
        return MainTabBarCoordinator(router: router, storageManager: storageManager, coordinatorFactory: coordinatorFactory, showLoginScreen: showLoginScreen)
    }
    
    func makeMapCoordinator(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator {
        let moduleFactory = MapModuleFactory()
        return MapCoordinator(moduleFactory: moduleFactory, storageManager: storageManager, coordinatorFactory: coordinatorFactory)
    }
    
    func makeProfileCoordinator(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator & UserProfileCoordinatorOutput {
        let moduleFactory = UserProfileModuleFactory(storageManager: storageManager)
        return UserProfileCoordinator(storageManager: storageManager, moduleFactory: moduleFactory, coordinatorFactory: coordinatorFactory)
    }
    
    func makeScanCoordinator(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator {
        return ScanCoordinator(storageManager: storageManager, coordinatorFactory: coordinatorFactory)
    }
    
    func makeAuthorizationCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & AuthorizationCoordinatorOutput {
        let moduleFactory = AuthorizationModuleFactory(storageManager: storageManager)
        return AuthorizationCoordinator(router: router, storageManager: storageManager, moduleFactory: moduleFactory)
    }
    
    func makeFiltersCoordinator(router: Router, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator & FiltersCoordinatorOutput {
        let moduleFactory = FiltersModuleFactory(storageManager: storageManager)
        return FiltersCoordinator(router: router, moduleFactory: moduleFactory, storageManager: storageManager, coordinatorFactory: coordinatorFactory)
    }
    
    func makeStartupCoordinator(router: Router) -> Coordinator & StartupCoordinatorOutput {
        let moduleFactory = StartupModuleFactory()
        return StartupCoordinator(router: router, moduleFactory: moduleFactory)
    }
    
    func makeLocationsCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & LocationsCoordinatorOutput & LocationsCoordinatorInput {
        let moduleFactory = LocationsModuleFactory(storageManager: storageManager)
        return LocationsCoordinator(router: router, moduleFactory: moduleFactory, storageManager: storageManager)
    }
    
    func makeLocationProcessCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & LocationProcessCoordinatorOutput {
        let moduleFactory = LocationProcessModuleFactory(storageManager: storageManager)
        return LocationProcessCoordinator(router: router, moduleFactory: moduleFactory, storageManager: storageManager)
    }
    
    func makeCitySelectionCoordinator(router: Router, storageManager: StorageManagerProtocol, cityId: String?) -> Coordinator & CitySelectionCoordinatorOutput {
        let moduleFactory = CitySelectionModuleFactory(storageManager: storageManager)
        return CitySelectionCoordinator(router: router, moduleFactory: moduleFactory, storageManager: storageManager, currentCityId: cityId)
    }
    
    func makeSettingsCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & SettingsCoordinatorOutput {
        let moduleFactory = SettingsModuleFactory(storageManager: storageManager)
        return SettingsCoordinator(router: router, storageManager: storageManager, moduleFactory: moduleFactory)
    }
}
