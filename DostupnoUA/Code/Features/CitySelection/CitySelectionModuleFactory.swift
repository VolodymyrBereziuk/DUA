//
//  CitySelectionModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 24.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol CitySelectionModuleFactoryProtocol {
    func makeCitySelectionModule(cityId: String?) -> (viewController: Presentable, nav: CitySelectionNavigation, presenter: CitySelectionPresenterProtocol)?
}

struct CitySelectionModuleFactory: CitySelectionModuleFactoryProtocol {
    
    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeCitySelectionModule(cityId: String?) -> (viewController: Presentable, nav: CitySelectionNavigation, presenter: CitySelectionPresenterProtocol)? {
        final class CitySelectionNav: CitySelectionNavigation {
            var didClearSelection: ((String) -> Void)?
            var didFinish: ((String, String?) -> Void)?
            var didCancel: (() -> Void)?
            
        }
        let navigation = CitySelectionNav()
        let presenter = CitySelectionPresenter(navigation: navigation, cityId: cityId)
        if let viewController = CitySelectionViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
