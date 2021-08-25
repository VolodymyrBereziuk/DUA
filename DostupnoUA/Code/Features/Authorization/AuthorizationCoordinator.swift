//
//  AuthorisationCoordinator.swift
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol AuthorizationCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator) -> Void)? { get set }
}

final class AuthorizationCoordinator: Coordinator, AuthorizationCoordinatorOutput {
        
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: AuthorizationModuleFactoryProtocol
    
    var didFinish: ((Coordinator) -> Void)?

    init(router: Router, storageManager: StorageManagerProtocol, moduleFactory: AuthorizationModuleFactoryProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runIntroScreen()
    }
    
    func runIntroScreen(_ option: DeepLinkOption? = nil) {
        guard var module = moduleFactory.makeRegistrationIntroModule() else { return }
        module.nav.toRegistrationScreen = { [weak self] in
            self?.runLoginScreen()
        }
        router.setRootModule(module.viewController, hideBar: false)
    }
    
    func runLoginScreen() {
        guard var module = moduleFactory.makeLoginModule() else { return }
        module.nav.toRegistration = { [weak self] in
            self?.runRegistrationScreen()
        }
        module.nav.toLoginEmail = { [weak self] in
            self?.runLoginEmailScreen()
        }
        module.nav.toUserProfile = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }

        router.push(module.viewController)
    }
    
    func runLoginEmailScreen() {
        guard var module = moduleFactory.makeLoginEmailModule() else { return }
        module.nav.toRegistration = { [weak self] in
            self?.runRegistrationScreen()
        }
        module.nav.toLoginEmail = { [weak self] in
            self?.runLoginEmailScreen()
        }
        module.nav.toUserProfile = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }
        module.nav.toRestorePassword = { [weak self] in
            self?.runRestorePasswordEmailScreen()
        }
        router.push(module.viewController)
    }
    
    func runRegistrationScreen() {
        guard var module = moduleFactory.makeRegistrationModule() else { return }
        module.nav.toCompleteRegistration = { [weak self] email in
            self?.runCompleteRegistration(email: email)
        }
        router.push(module.viewController)
    }
    
    func runCompleteRegistration(email: String?) {
        guard var module = moduleFactory.makeCompleteRegistrationModule(email: email) else { return }
        module.nav.toUserProfile = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }
        router.push(module.viewController)
    }
    
    func runRestorePasswordEmailScreen() {
        guard var module = moduleFactory.makeRestorePasswordEmailModule() else { return }
        module.nav.toNewPassword = { [weak self] email in
            self?.runRestorePasswordNewPasswordScreen(email: email)
        }
        router.push(module.viewController)
    }
    
    func runRestorePasswordNewPasswordScreen(email: String?) {
        guard var module = moduleFactory.makeRestorePasswordNewPasswordModule(email: email) else { return }
        module.nav.toUserProfile = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }
        router.push(module.viewController)
    }
}
