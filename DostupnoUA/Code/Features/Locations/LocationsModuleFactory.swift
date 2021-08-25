//
//  LocationsModuleFactory.swift
//  DostupnoUA
//
//  Created by Anton on 12.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol LocationsModuleFactoryProtocol {
    func makeLocationListModule(isFavouriteState: Bool) -> (viewController: Presentable, nav: LocationListNavigation, presenter: LocationListPresenterProtocol)?
    func makeLocationListModule(requestText: String?, locationsResponse: LocationsResponse) -> (viewController: Presentable, nav: LocationListNavigation, presenter: LocationListPresenterProtocol)?
    func makeLocationDetailsModule(location: Location?) -> (viewController: Presentable, nav: LocationDetailsNavigation, presenter: LocationDetailsPresenterProtocol)?
    func makeLocationMapPositionModule(location: Location?) -> (viewController: Presentable, nav: LocationMapPositionNavigation, presenter: LocationMapPositionPresenterProtocol)?
}

struct LocationsModuleFactory: LocationsModuleFactoryProtocol {

    let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
    }
    
    func makeLocationListModule(isFavouriteState: Bool) -> (viewController: Presentable, nav: LocationListNavigation, presenter: LocationListPresenterProtocol)? {
        final class LocationListNav: LocationListNavigation {
            var toMap: (() -> Void)?
            var toUserProfile: (() -> Void)?
            var toLocationDetails: ((Location) -> Void)?
        }
        let navigation = LocationListNav()
        let presenter = LocationListPresenter(navigation: navigation, isFavouriteState: isFavouriteState)
        if let viewController = LocationListViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeLocationListModule(requestText: String? = nil, locationsResponse: LocationsResponse) -> (viewController: Presentable, nav: LocationListNavigation, presenter: LocationListPresenterProtocol)? {
        final class LocationListNav: LocationListNavigation {
            var toMap: (() -> Void)?
            var toUserProfile: (() -> Void)?
            var toLocationDetails: ((Location) -> Void)?
        }
        let navigation = LocationListNav()
        let presenter = LocationListPresenter(navigation: navigation, requestText: requestText, locationsResponse: locationsResponse)
        if let viewController = LocationListViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeLocationDetailsModule(location: Location?) -> (viewController: Presentable, nav: LocationDetailsNavigation, presenter: LocationDetailsPresenterProtocol)? {
        
        final class LocationDetailsNav: LocationDetailsNavigation {
            var toLocationList: (() -> Void)?
            var toLocationMapPosition: ((Location?) -> Void)?
            var toComments: ((Location?) -> Void)?
        }
        let navigation = LocationDetailsNav()
        let presenter = LocationDetailsPresenter(navigation: navigation, location: location)
        if let viewController = LocationDetailsViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeLocationMapPositionModule(location: Location?) -> (viewController: Presentable, nav: LocationMapPositionNavigation, presenter: LocationMapPositionPresenterProtocol)? {
        
        final class LocationMapPositionNav: LocationMapPositionNavigation {
            var toLocationDetails: (() -> Void)?
        }
        let navigation = LocationMapPositionNav()
        let presenter = LocationMapPositionPresenter(navigation: navigation, location: location)
        if let viewController = LocationMapPositionViewController.make(with: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeCommentsModule(location: Location?) -> (viewController: Presentable, nav: CommentsNavigation, presenter: CommentsPresenterProtocol)? {
        final class CommentsNav: CommentsNavigation {
            var toCreateComment: (() -> Void)?
        }
        let navigation = CommentsNav()
        let presenter = CommentsPresenter(navigation: navigation, location: location)
        if let viewController = CommentsViewController.make(presenter: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
    
    func makeNewCommentModule(location: Location?) -> (viewController: Presentable, nav: NewCommentNavigation, presenter: NewCommentPresenterProtocol)? {
        final class NewCommentNav: NewCommentNavigation {
            var didTapBack: (() -> Void)?
        }
        let navigation = NewCommentNav()
        let presenter = NewCommentPresenter(navigation: navigation, location: location)
        if let viewController = NewCommentViewController.make(presenter: presenter) {
            return (viewController, navigation, presenter)
        }
        return nil
    }
}
