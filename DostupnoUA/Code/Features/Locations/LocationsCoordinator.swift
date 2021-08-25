//
//  LocationsCoordinator.swift
//  DostupnoUA
//
//  Created by Anton on 12.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol LocationsCoordinatorInput {
    var didGetMapInfo: (() -> (searchText: String?, locationsResponse: LocationsResponse))? { get set }
    var didShowFavouriteLocations: (() -> Void)? { get set }
    var didShowLocationDetails: (() -> (Location?))? { get set }
}

protocol LocationsCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator) -> Void)? { get set }
    var didCancel: ((_ coordinator: Coordinator) -> Void)? { get set }
}

final class LocationsCoordinator: Coordinator, LocationsCoordinatorOutput, LocationsCoordinatorInput {
    
    var didShowLocationDetails: (() -> (Location?))?
    var didGetMapInfo: (() -> (searchText: String?, locationsResponse: LocationsResponse))?
    var didShowFavouriteLocations: (() -> Void)?

    var didCancel: ((Coordinator) -> Void)?
    var didFinish: ((Coordinator) -> Void)?
    
    private let storageManager: StorageManagerProtocol
    private let moduleFactory: LocationsModuleFactory
    
    init(router: Router, moduleFactory: LocationsModuleFactory, storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        let router = router
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        runLocationList()
    }
    
    func runLocationList() {
        if let mapInfo = didGetMapInfo?() {
            let listModule = moduleFactory.makeLocationListModule(requestText: mapInfo.searchText, locationsResponse: mapInfo.locationsResponse)
            guard var module = listModule else { return }
            module.nav.toMap = { [weak self] in
                self?.router.popModule()
            }
            module.nav.toLocationDetails = { [weak self] location in
                self?.runLocationDetails(location: location)
            }
            router.push(module.viewController)
        }
        if (didShowFavouriteLocations?()) != nil {
            let listModule = moduleFactory.makeLocationListModule(isFavouriteState: true)
            guard var module = listModule else { return }
            module.nav.toUserProfile = { [weak self] in
                self?.router.popModule()
            }
            module.nav.toLocationDetails = { [weak self] location in
                self?.runLocationDetails(location: location)
            }
            router.push(module.viewController)
        }
    }
    
    func runLocationDetails(location: Location?) {
        let locationDetailsToShow = didShowLocationDetails?()
        let loc = locationDetailsToShow ?? location
        guard var module = moduleFactory.makeLocationDetailsModule(location: loc) else { return }
        module.nav.toLocationList = { [weak self] in
            self?.router.popModule()
        }
        module.nav.toLocationMapPosition = { [weak self] location in
            self?.runLocationMapPosition(location: location)
        }
        module.nav.toComments = { [weak self] location in
            self?.runLocationComments(location: location)
        }
        router.push(module.viewController)
    }
    
    func runLocationMapPosition(location: Location?) {
        var module = moduleFactory.makeLocationMapPositionModule(location: location)
        module?.nav.toLocationDetails = { [weak self] in
            self?.router.popModule()
        }
        router.push(module?.viewController)
    }
    
    func runLocationComments(location: Location?) {
        var module = moduleFactory.makeCommentsModule(location: location)
        module?.nav.toCreateComment = { [weak self] in
            self?.runCreateComment(location: location)
        }
        router.push(module?.viewController)
    }
    
    func runCreateComment(location: Location?) {
        var module = moduleFactory.makeNewCommentModule(location: location)
        module?.nav.didTapBack = { [weak self] in
            self?.router.popModule(animated: true)
        }
        router.push(module?.viewController)
    }
}
