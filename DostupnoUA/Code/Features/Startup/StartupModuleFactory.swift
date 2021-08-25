//
//  StartupModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

protocol StartupModuleFactoryProtocol {
    func makeStartupModule() -> (viewController: Presentable, nav: StartupNavigation, presenter: StartupPresenterProtocol)?
}

struct StartupModuleFactory: StartupModuleFactoryProtocol {
        
    func makeStartupModule() -> (viewController: Presentable, nav: StartupNavigation, presenter: StartupPresenterProtocol)? {
        final class StartupNav: StartupNavigation {
            var onFinish: ((Bool) -> Void)?
        }
        let navigation = StartupNav()
        let presenter = StartupPresenter(navigation: navigation)
        if let viewController = StartupViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
