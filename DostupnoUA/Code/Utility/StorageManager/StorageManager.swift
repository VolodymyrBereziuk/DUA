//
//  CityManager.swift
//  OpenWeatherMap
//
//  Created by Viktor Drykin on 13.03.2018.
//  Copyright © 2018 Viktor Drykin. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol {
    func getFilters(language: String,
                    forceDownload: Bool,
                    onSuccess: @escaping (FiltersList) -> Void,
                    onFailure: @escaping (Error) -> Void)
    
    func getUserProfile(language: String,
                        forceDownload: Bool,
                        onSuccess: @escaping (UserProfile) -> Void,
                        onFailure: @escaping (Error) -> Void)
    
    func getUserFavouriteIDs(language: String,
                             forceDownload: Bool,
                             onSuccess: @escaping ([Int]) -> Void,
                             onFailure: @escaping (Error) -> Void)
    
    func appendToFavouritesLocation(id: Int)
    func removeFromFavouritesLocation(id: Int)

}

public class StorageManager: StorageManagerProtocol {
        
    static let shared = StorageManager()
    
    private init() {}
    
    private var filterList: FiltersList?
    private var filterListLanguage: String?
    
    private var userProfile: UserProfile?
    private var userProfileLanguage: String?
    
    var currentCityId: String?
    var mapLocationBounds: LocationCoordinateBounds?
    
    var favouritesIDs: Set<Int>?
    
    func clearContent() {
        userProfile = nil
        userProfileLanguage = nil
        currentCityId = nil
    }
    
    func getFilters(language: String = LocalisationManager.shared.currentLanguage.rawValue,
                    forceDownload: Bool = false,
                    onSuccess: @escaping (FiltersList) -> Void,
                    onFailure: @escaping (Error) -> Void = { _ in }) {
        if filterListLanguage == language, let filterList = filterList, forceDownload == false {
            onSuccess(filterList)
            return
        }
        let connection = GetFiltersConnection(language: language)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] filters in
            self?.filterListLanguage = language
            self?.filterList = filters
            onSuccess(filters)
        }, failureHandler: { error in
            onFailure(error)
        })
    }
    
    func getUserProfile(language: String = LocalisationManager.shared.currentLanguage.rawValue,
                        forceDownload: Bool = false,
                        onSuccess: @escaping (UserProfile) -> Void,
                        onFailure: @escaping (Error) -> Void = { _ in }) {
        if userProfileLanguage == language, let userProfile = userProfile, forceDownload == false {
            onSuccess(userProfile)
            return
        }
        let userProfileConnection = UserProfileConnection()
        APIClient.shared.start(connection: userProfileConnection, successHandler: { [weak self] user in
            self?.userProfileLanguage = language
            self?.userProfile = user
            self?.currentCityId = user.city
            onSuccess(user)
        }, failureHandler: { error in
            onFailure(error)
        })
    }
    
    func getUserFavouriteIDs(language: String = LocalisationManager.shared.currentLanguage.rawValue,
                             forceDownload: Bool = false,
                             onSuccess: @escaping ([Int]) -> Void,
                             onFailure: @escaping (Error) -> Void  = { _ in }) {
        if userProfileLanguage == language, let favourites = favouritesIDs, forceDownload == false {
            onSuccess(Array(favourites))
            return
        }
        let connection = GetFavouritesLocationsIDsConnection(language: language)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] ids in
            self?.userProfileLanguage = language
            self?.favouritesIDs = Set(ids)
            onSuccess(ids)
        }, failureHandler: { error in
            onFailure(error)
        })
    }
    
    func appendToFavouritesLocation(id: Int) {
        if favouritesIDs == nil {
            favouritesIDs = Set([id])
        } else {
            favouritesIDs?.insert(id)
        }
    }
    
    func removeFromFavouritesLocation(id: Int) {
        favouritesIDs?.remove(id)
    }
    
    func filtersIdForLocations() -> [String: [String]] {
        var info = [String: [String]]()
        filterList?.main?.forEach({
            if let mainInfo = $0.requestLocationsInfo {
                info.merge(mainInfo, uniquingKeysWith: { first, _ in first })
            }
        })
        return info
    }
    
    var firstDisplayedCityFilter: Filter? {
        if let cityId = userProfile?.city ?? filterList?.cities?.defaultFilter {
            return filterList?.cities?.filters?.first(where: { $0.id == cityId })
        }
        return nil
    }
    
    func allHiddenFilters() -> [String: [String]] {
        var totalHideFilters = [String: [String]]()
        filterList?.main?.forEach({ mainFilter in
            mainFilter.filters?.forEach({ filter in
                if let content = filter.hideFilters, !content.isEmpty {
                    totalHideFilters[filter.id] = content
                }
                getChildFiters(filter: filter, totalHideFilters: &totalHideFilters)
            })
        })
        return totalHideFilters
    }
    
    private func getChildFiters(filter: Filter?, totalHideFilters: inout [String: [String]]) {
        filter?.children?.forEach({ childFilter in
            if let childContent = childFilter.hideFilters, !childContent.isEmpty {
                totalHideFilters[childFilter.id] = childContent
            }
            getChildFiters(filter: childFilter, totalHideFilters: &totalHideFilters)
        })
    }
}
