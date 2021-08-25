//
//  AuthorisationModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation
import UIKit

protocol AuthorizationModuleFactoryProtocol {    
    func makeLoginModule() -> (viewController: Presentable, nav: LoginNavigation, presenter: LoginPresenterProtocol)?
    func makeLoginEmailModule() -> (viewController: Presentable, nav: LoginNavigation, presenter: LoginEmailPresenterProtocol)?
    func makeRegistrationModule() -> (viewController: Presentable, nav: RegisterNavigation)?
    func makeCompleteRegistrationModule(email: String?) -> (viewController: Presentable, nav: CompleteRegistrationNavigation)?
    func makeRestorePasswordEmailModule() -> (viewController: Presentable, nav: RestorePasswordNavigation)?
    func makeRestorePasswordNewPasswordModule(email: String?) -> (viewController: Presentable, nav: RestorePasswordNewPasswordNavigation)?
    func makeRegistrationIntroModule() -> (viewController: Presentable, nav: RegistrationIntroNavigation)?
}

struct AuthorizationModuleFactory: AuthorizationModuleFactoryProtocol {

    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeLoginModule() -> (viewController: Presentable, nav: LoginNavigation, presenter: LoginPresenterProtocol)? {
        final class LoginNav: LoginNavigation {
            var toRestorePassword: (() -> Void)?
            var toRegistration: (() -> Void)?
            var toUserProfile: (() -> Void)?
            var toLoginEmail: (() -> Void)?
        }
        let navigation = LoginNav()
        let presenter = LoginPresenter(navigation: navigation)
        if let viewController = LoginViewController.make(presenter: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeLoginEmailModule() -> (viewController: Presentable, nav: LoginNavigation, presenter: LoginEmailPresenterProtocol)? {
        final class LoginNav: LoginNavigation {
            var toRestorePassword: (() -> Void)?
            var toRegistration: (() -> Void)?
            var toUserProfile: (() -> Void)?
            var toLoginEmail: (() -> Void)?
        }
        let navigation = LoginNav()
        let presenter = LoginPresenter(navigation: navigation)
        if let viewController = LoginEmailViewController.make(presenter: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeRegistrationModule() -> (viewController: Presentable, nav: RegisterNavigation)? {
        final class RegisterNav: RegisterNavigation {
            var toCompleteRegistration: ((String?) -> Void)?
        }
        let navigation = RegisterNav()
        if let viewController = RegistrationViewController.make(navigation: navigation) {
            return (viewController, navigation)
        }
        return nil
    }
    
    func makeCompleteRegistrationModule(email: String?) -> (viewController: Presentable, nav: CompleteRegistrationNavigation)? {
        final class CompleteRegistrationNav: CompleteRegistrationNavigation {
            var toUserProfile: (() -> Void)?
        }
        let navigation = CompleteRegistrationNav()
        if let viewController = CompleteRegistrationViewController.make(navigation: navigation) {
            viewController.email = email
            return (viewController, navigation)
        }
        return nil
    }
    
    func makeRestorePasswordEmailModule() -> (viewController: Presentable, nav: RestorePasswordNavigation)? {
        final class RestorePasswordNav: RestorePasswordNavigation {
            var toNewPassword: ((String?) -> Void)?
        }
        let navigation = RestorePasswordNav()
        if let viewController = RestorePasswordEmailViewController.make(navigation: navigation) {
            return (viewController, navigation)
        }
        return nil
    }
    
    func makeRestorePasswordNewPasswordModule(email: String?) -> (viewController: Presentable, nav: RestorePasswordNewPasswordNavigation)? {
        final class RestorePasswordNewPasswordNav: RestorePasswordNewPasswordNavigation {
            var toUserProfile: (() -> Void)?
        }
        let navigation = RestorePasswordNewPasswordNav()
        if let viewController = RestorePasswordNewPasswordViewController.make(navigation: navigation) {
            viewController.email = email
            return (viewController, navigation)
        }
        return nil
    }
    
    func makeRegistrationIntroModule() -> (viewController: Presentable, nav: RegistrationIntroNavigation)? {
        final class RegistrationIntroNav: RegistrationIntroNavigation {
            var toRegistrationScreen: (() -> Void)?
        }
        let navigation = RegistrationIntroNav()
        if let viewController = RegistrationIntroViewController.make(navigation: navigation) {
            return (viewController, navigation)
        }
        return nil
    }
}
