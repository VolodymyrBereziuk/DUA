//
//  MapModuleFactory.swift
//  DostupnoUA
//
//  Created by admin on 13.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol MapModuleFactoryProtocol {
    func makeMapModule() -> (viewController: Presentable, nav: MapNavigation, presenter: MapPresenterProtocol)?
}

struct MapModuleFactory: MapModuleFactoryProtocol {
    
    func makeMapModule() -> (viewController: Presentable, nav: MapNavigation, presenter: MapPresenterProtocol)? {
        final class MapNav: MapNavigation {
            var toLocationDetails: ((Location?) -> Void)?
            var toLocationList: ((String?, LocationsResponse) -> Void)?
            var toFiltersList: (() -> Void)?
            var toCreateLocation: (() -> Void)?
        }
        let navigation = MapNav()
        let presenter = MapPresenter(navigation: navigation)
        if let viewController = MapViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
