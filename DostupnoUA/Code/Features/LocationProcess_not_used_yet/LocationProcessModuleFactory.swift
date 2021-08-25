//
//  LocationProcessModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol LocationProcessModuleFactoryProtocol {
    func makeCreationIntroModule() -> (viewController: Presentable, nav: CreationIntroNavigation, presenter: CreationIntroPresenterProtocol)?
}

struct LocationProcessModuleFactory: LocationProcessModuleFactoryProtocol {

    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeCreationIntroModule() -> (viewController: Presentable, nav: CreationIntroNavigation, presenter: CreationIntroPresenterProtocol)? {
        final class CreationIntroNav: CreationIntroNavigation {
            var didClose: (() -> Void)?
            var didNext: (() -> Void)?
        }
        let navigation = CreationIntroNav()
        let presenter = CreationIntroPresenter(navigation: navigation)
        if let viewController = CreationIntroViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
