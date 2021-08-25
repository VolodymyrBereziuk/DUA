//
//  SearchPlacesPresenter.swift
//  DostupnoUA
//
//  Created by admin on 26.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol SearchPlacesViewProtocol: AnyObject {
    var onShowAllPlacesDidTap: (() -> Void)? { get set }
    var onPlaceDidSelect: ((Int?) -> Void)? { get set }
    
    func reloadPlacesView(with places: [SearchBarPlace])
    func cleanPlacesView()
    func setSearchView(isHidden: Bool)
    func setTotalResults(value: Int?)
    func updateContentLanguage()
}

protocol SearchPlacesPresenterProtocol {
    var managedView: SearchPlacesViewProtocol? { get set }
    var getLocationsResponse: LocationsResponse? { get }
    
    func getLocations(by text: String?)
    func cleanPlacesView(isTextEmpty: Bool)
    func getLocation(by id: Int?) -> Location?
}

class SearchPlacesPresenter: SearchPlacesPresenterProtocol {
    
    weak var managedView: SearchPlacesViewProtocol?
    var locationsReponse: LocationsResponse?
    var searchText: String?
    
    func getLocations(by text: String?) {
        
        searchText = text
        let language = LocalisationManager.shared.currentLanguage.rawValue
        let city = StorageManager.shared.currentCityId
        let filters = StorageManager.shared.filtersIdForLocations()
        let model = LocationConnectionParametersModel(text: text,
                                                      city: city,
                                                      language: language,
                                                      filters: filters,
                                                      mapLocationBounds: StorageManager.shared.mapLocationBounds,
                                                      onlyCoordinateResults: false)
        let locationListConnection = GetLocationListConnection(parametersModel: model)
        APIClient.shared.start(connection: locationListConnection,
                               successHandler: { [weak self] locationResponse in
                                guard let self = self, self.searchText?.contains(text ?? "") == true else {
                                    return
                                }
                                self.locationsReponse = locationResponse
                                self.searchText = text
                                let locations = self.locationsReponse?.items ?? []
                                let searchedPlaces = self.convertToSearchPlaces(locations: locations)
                                
                                self.managedView?.reloadPlacesView(with: searchedPlaces)
                                self.managedView?.setTotalResults(value: self.locationsReponse?.total)
            },
                               failureHandler: { [weak self] _ in
                                self?.managedView?.reloadPlacesView(with: [])
                                self?.managedView?.setTotalResults(value: nil)
        })
    }
    
    func cleanPlacesView(isTextEmpty: Bool) {
        if isTextEmpty {
            managedView?.reloadPlacesView(with: [])
        }
    }
    
    var getLocationsResponse: LocationsResponse? {
        return locationsReponse
    }
    
    func getLocation(by id: Int?) -> Location? {
        guard let id = id else {
            return nil
        }
        return locationsReponse?.items?.first(where: { $0.id == id })
    }
    
    private func convertToSearchPlaces(locations: [Location]?) -> [SearchBarPlace] {
        guard let locations = locations else {
            return []
        }
        
        let searchedPlaces = locations.map {
            SearchBarPlace(id: $0.id, name: $0.title, gradeColor: $0.getGradeColor())
        }
        return searchedPlaces
    }
    
}
