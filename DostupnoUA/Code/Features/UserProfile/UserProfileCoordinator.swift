//
//  ProfileCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol UserProfileCoordinatorOutput {
    var onSuccessAuthentication: ((_ coordinator: Coordinator) -> Void)? { get set }
}

final class UserProfileCoordinator: Coordinator, UserProfileCoordinatorOutput {
    var onSuccessAuthentication: ((Coordinator) -> Void)?
    
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: UserProfileModuleFactoryProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    init(storageManager: StorageManagerProtocol, moduleFactory: UserProfileModuleFactoryProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        super.init(router: Router(rootController: NavigationController()))
    }
    
    override func start(with option: DeepLinkOption?) {
        
        if PersistenceManager.manager.isLoggedIn {
            runUserProfile()
        } else {
            runAuthorizationFlow()
        }
    }
    
    func runUserProfile() {
        guard var profileModule = moduleFactory.makeProfileModule() else {
            return
        }
        profileModule.nav.toEditProfile = { [weak self] profile in
            self?.runEditProfile(profile)
        }
        profileModule.nav.toAuthorizationFlow = { [weak self] in
            self?.runAuthorizationFlow()
        }
        profileModule.nav.toSettings = { [weak self] in
            self?.runSettings()
        }
        profileModule.nav.toFavouriteLocations = { [weak self] in
            self?.runFavouriteLocations()
        }
        router.setRootModule(profileModule.viewController, hideBar: false)
    }
    
    func runAuthorizationFlow() {
        var authorisationCoordinator = coordinatorFactory.makeAuthorizationCoordinator(router: router, storageManager: storageManager)
        addDependency(authorisationCoordinator)
        authorisationCoordinator.start()
        
        authorisationCoordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            if PersistenceManager.manager.dostupnoToken?.isNewUser?.isTrue == true {
                self?.runPopupFlow()
            } else if let self = self {
                self.runUserProfile()
                self.onSuccessAuthentication?(self)
            }
        }
        let module = authorisationCoordinator.router.toPresent() as? NavigationController
        router.setRootModule(module?.viewControllers.last, hideBar: false)
    }
    
    func runEditProfile(_ profile: UserProfile) {
        guard var module = moduleFactory.makeEditableProfileModule(profile: profile) else {
            return
        }
        module.nav.backToProfile = { [weak self] in
            self?.router.popModule(animated: true)
        }
        module.nav.reloadProfile = { [weak self] in
            self?.router.popModule(animated: true)
            self?.runUserProfile()
        }
        module.nav.toCitySelection = { [weak self] cityId in
            self?.runCitySelection(currentCityId: cityId, completion: { updateCityID, cityName in
                module.presenter.updateCity(id: updateCityID, name: cityName)
            })
        }
        router.push(module.viewController)
    }
    
    func runPopupFlow() {
        var popupCoordinator = coordinatorFactory.makePopupCoordinator(router: router, storageManager: storageManager, popupType: .registerConfirmation)
        addDependency(popupCoordinator)
        popupCoordinator.start()
        
        popupCoordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.runUserProfile()
            if let self = self {
                self.onSuccessAuthentication?(self)
            }
        }
        popupCoordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.runUserProfile()
            if let self = self {
                self.onSuccessAuthentication?(self)
            }
        }
        let module = popupCoordinator.router.topmostPresented()
        router.setRootModule(module, hideBar: true)
        //        router.present(module, animated: true)
    }
    
    func runCitySelection(currentCityId: String?, completion: @escaping((_ cityID: String, _ cityName: String?) -> Void)) {
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
    }
    
    func runSettings() {
        var settingsCoordinator = coordinatorFactory.makeSettingsCoordinator(router: router, storageManager: storageManager)
        addDependency(settingsCoordinator)
        settingsCoordinator.start()
        
        settingsCoordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popModule(animated: true)
        }
        settingsCoordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            self?.router.popModule(animated: true)
        }
    }
    
    func runFavouriteLocations() {
        var coordinator = coordinatorFactory.makeLocationsCoordinator(router: router, storageManager: storageManager)
        addDependency(coordinator)
        coordinator.didShowFavouriteLocations = { }
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
}

extension UserProfileCoordinator {
    
    func runMockedPopupVersion1() {
        var popupCoordinator = coordinatorFactory.makePopupCoordinator(router: router, storageManager: storageManager, popupType: .featureInProgress(feature: .profile))
        addDependency(popupCoordinator)
        popupCoordinator.start()
        
        popupCoordinator.didCancel = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            
        }
        popupCoordinator.didFinish = { [weak self] coordinator in
            self?.removeDependency(coordinator)
            
        }
    }
}
