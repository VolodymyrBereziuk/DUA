//
//  SettingsModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol SettingsModuleFactoryProtocol {
    func makeSettingsModule() -> (viewController: Presentable, nav: SettingsNavigation, presenter: SettingsPresenterProtocol)?
    func makeLanguagesModule() -> (viewController: Presentable, presenter: LanguagesPresenterProtocol)?
}

struct SettingsModuleFactory: SettingsModuleFactoryProtocol {

    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeSettingsModule() -> (viewController: Presentable, nav: SettingsNavigation, presenter: SettingsPresenterProtocol)? {
        final class SettingsNav: SettingsNavigation {
            var didFinish: (() -> Void)?
            var toLocalisation: (() -> Void)?
        }
        let navigation = SettingsNav()
        let presenter = SettingsPresenter(navigation: navigation)
        if let viewController = SettingsViewController.make(presenter: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeLanguagesModule() -> (viewController: Presentable, presenter: LanguagesPresenterProtocol)? {
        let presenter = LanguagesPresenter()
        if let viewController = LanguagesViewController.make(presenter: presenter) {
            return (viewController, presenter)
        }
        return nil
    }
}
