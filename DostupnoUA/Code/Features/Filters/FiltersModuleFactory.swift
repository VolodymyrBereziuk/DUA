//
//  FiltersModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol FiltersModuleFactoryProtocol {
    func makeMainFiltersModule() -> (viewController: Presentable, nav: MainFiltersNavigation, presenter: MainFiltersPresenterProtocol)?
    func makeFiltersModule(filterSelectionInfo: FilterSelectionInfo) -> (viewController: Presentable, nav: FiltersNavigation, presenter: FiltersPresenterProtocol)?
}

struct FiltersModuleFactory: FiltersModuleFactoryProtocol {
    
    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeMainFiltersModule() -> (viewController: Presentable, nav: MainFiltersNavigation, presenter: MainFiltersPresenterProtocol)? {
        final class MainFiltersNav: MainFiltersNavigation {
            var toCitySelection: ((String?) -> Void)?
            var toGetLocations: (() -> Void)?
            var didFinish: (() -> Void)?
            var toFilter: ((FilterSelectionInfo) -> Void)?
        }
        let navigation = MainFiltersNav()
        let presenter = MainFiltersPresenter(navigation: navigation)
        if let viewController = MainFiltersViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeFiltersModule(filterSelectionInfo: FilterSelectionInfo) -> (viewController: Presentable, nav: FiltersNavigation, presenter: FiltersPresenterProtocol)? {
        final class FiltersNav: FiltersNavigation {
            var toGetLocations: (() -> Void)?
            var didFinish: (() -> Void)?
            var toFilter: ((FilterSelectionInfo) -> Void)?
        }
        let navigation = FiltersNav()
        let presenter = FiltersPresenter(navigation: navigation, filterSelectionInfo: filterSelectionInfo)
        if let viewController = FiltersViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
