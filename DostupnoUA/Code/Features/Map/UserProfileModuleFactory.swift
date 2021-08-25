//
//  UserProfileModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 14.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol UserProfileModuleFactoryProtocol {
    func makeProfileModule() -> (viewController: Presentable, nav: UserProfileNavigation, viewModel: UserProfilePresenter)?
    func makeEditableProfileModule(profile: UserProfile) -> (viewController: Presentable, nav: EditableProfileNavigation, presenter: EditableProfilePresenter)?
}

struct UserProfileModuleFactory: UserProfileModuleFactoryProtocol {

    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeProfileModule() -> (viewController: Presentable, nav: UserProfileNavigation, viewModel: UserProfilePresenter)? {
        final class UserProfileNav: UserProfileNavigation {
            var toSettings: (() -> Void)?
            var toAuthorizationFlow: (() -> Void)?
            var toEditProfile: ((UserProfile) -> Void)?
            var toFavouriteLocations: (() -> Void)?
        }
        let navigation = UserProfileNav()
        let viewModel = UserProfilePresenter(navigation: navigation)
        if let viewController = UserProfileViewController.make(withViewModel: viewModel) {
            viewModel.managedView = viewController
            return (viewController, navigation, viewModel)
        }
        return nil
    }
    
    func makeEditableProfileModule(profile: UserProfile) -> (viewController: Presentable, nav: EditableProfileNavigation, presenter: EditableProfilePresenter)? {
        final class EditableProfileNav: EditableProfileNavigation {
            var toCitySelection: ((String?) -> Void)?
            var reloadProfile: (() -> Void)?
            var backToProfile: (() -> Void)?
        }
        let navigation = EditableProfileNav()
        let presenter = EditableProfilePresenter(navigation: navigation, profile: profile)
        if let viewController = EditableProfileViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
