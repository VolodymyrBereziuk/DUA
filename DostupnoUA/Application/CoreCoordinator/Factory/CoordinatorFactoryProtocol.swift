//
//  CoordinatorFactoryProtocol.swift
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    
    func makeStartupCoordinator(router: Router) -> Coordinator & StartupCoordinatorOutput
    
    func makeMainTabBarCoordinator(router: Router, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol, showLoginScreen: Bool) -> Coordinator
    
    func makeMapCoordinator(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator
    
    func makeProfileCoordinator(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator & UserProfileCoordinatorOutput
    
    func makeScanCoordinator(storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator
    
    func makeAuthorizationCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & AuthorizationCoordinatorOutput
    
    func makePopupCoordinator(router: Router, storageManager: StorageManagerProtocol, popupType: PopupType) -> Coordinator & PopupCoordinatorOutput

    func makeFiltersCoordinator(router: Router, storageManager: StorageManagerProtocol, coordinatorFactory: CoordinatorFactoryProtocol) -> Coordinator & FiltersCoordinatorOutput
    
    func makeLocationsCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & LocationsCoordinatorOutput & LocationsCoordinatorInput
    
    func makeLocationProcessCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & LocationProcessCoordinatorOutput
    
    func makeCitySelectionCoordinator(router: Router, storageManager: StorageManagerProtocol, cityId: String?) -> Coordinator & CitySelectionCoordinatorOutput
    
    func makeSettingsCoordinator(router: Router, storageManager: StorageManagerProtocol) -> Coordinator & SettingsCoordinatorOutput
}
