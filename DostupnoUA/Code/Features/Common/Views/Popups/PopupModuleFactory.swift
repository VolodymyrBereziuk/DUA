//
//  PopupModuleFactory.swift
//  DostupnoUA
//
//  Created by Anton on 25.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol PopupModuleFactoryProtocol {
    func makePopupGenericModule(type: PopupType) -> (Presentable)?
    func makePopupGreenBottomModule(type: PopupType) -> (viewController: Presentable, nav: PopupGreenBottomNavigation)?
    func makePopupTableModule() -> Presentable?
}

struct PopupModuleFactory: PopupModuleFactoryProtocol {
    
    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makePopupGenericModule(type: PopupType) -> (Presentable)? {
        return PopupGenericViewController.make(type: type)
    }
    
    func makePopupGreenBottomModule(type: PopupType) -> (viewController: Presentable, nav: PopupGreenBottomNavigation)? {
        final class PopupGreenBottomNav: PopupGreenBottomNavigation {
            var toUserProfile: (() -> Void)?
        }
        let navigation = PopupGreenBottomNav()
        if let viewController = PopupGreenBottomViewController.make(type: type, navigation: navigation) {
            return (viewController, navigation)
        }
        return nil
    }
    
    func makePopupTableModule() -> Presentable? {
        return PopupTableViewController.make()
    }

}
