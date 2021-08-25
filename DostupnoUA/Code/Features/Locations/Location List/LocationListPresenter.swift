//
//  LocationListPresenter.swift
//  DostupnoUA
//
//  Created by Anton on 12.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

protocol LocationListNavigation {
    var toMap: (() -> Void)? { get set }
    var toUserProfile: (() -> Void)? { get set }
    var toLocationDetails: ((Location) -> Void)? { get set }
}

protocol LocationListViewProtocol: AnyObject {
    func reloadTableView()
    func setSearchBar(text: String?)
    func getFavouriteLocationsContent()
}

protocol LocationListPresenterProtocol: AnyObject {
    
    var managedView: LocationListViewProtocol? { get set }
    var numberOfRows: Int? { get }
    var isFavouriteAppearance: Bool { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func getLocations(by text: String?, completionHandler: (() -> Void)?)
    func getFavouriteLocations(completion: @escaping (Result<Void, Error>) -> Void)
    func location(at indexPath: IndexPath) -> Location?
    func locationTypeTitle(at indexPath: IndexPath) -> String?
    //    func likeLocation(at indexPath: IndexPath?)
    func didSelectLocation(at indexPath: IndexPath)
    func clearAllLocations()
    func backTapped()
    func showLocationList(searchText: String?, locationsReponse: LocationsResponse)
    func showLocationDetails(location: Location)
    func allLocationsAlreadyLoaded() -> Bool
    func isFavouriteLocation(location: Location?) -> Bool
    func changeLocationStatus(at indexPath: IndexPath?, completion: @escaping (Result<Void, Error>) -> Void)
    func errorTitle(for error: Error) -> String
}

extension LocationListPresenterProtocol {
    func getLocations(by text: String?, completionHandler: (() -> Void)? = nil) {
        getLocations(by: text, completionHandler: completionHandler)
    }
}

class LocationListPresenter: LocationListPresenterProtocol {
    
    weak var managedView: LocationListViewProtocol?
    var navigation: LocationListNavigation
    
    private var locations = [Location]()
    private var locationsResponse: LocationsResponse?
    private var request: String?
    private var mainFilters: [MainFilter]?
    private var favouriteLocationIDs = [Int]()
    
    private var isFavouriteState = false
    
    var isFavouriteAppearance: Bool {
        return isFavouriteState
    }
    
    var numberOfRows: Int? {
        return locations.count
    }
    
    init(navigation: LocationListNavigation, requestText: String?, locationsResponse: LocationsResponse) {
        request = requestText
        self.navigation = navigation
        self.locationsResponse = locationsResponse
        locations = locationsResponse.items ?? []
    }
    
    init(navigation: LocationListNavigation, isFavouriteState: Bool) {
        self.navigation = navigation
        self.isFavouriteState = isFavouriteState
    }
    
    func viewDidLoad() {
        if isFavouriteAppearance {
            managedView?.getFavouriteLocationsContent()
        } else {
            StorageManager.shared.getFilters(onSuccess: { [weak self] filterList in
                self?.mainFilters = filterList.main
                StorageManager.shared.getUserFavouriteIDs(onSuccess: { [weak self] ids in
                    self?.favouriteLocationIDs = ids
                    self?.managedView?.reloadTableView()
                }, onFailure: { _ in
                    self?.managedView?.reloadTableView()
                })
            })
            managedView?.setSearchBar(text: request)
        }
    }
    
    func viewWillAppear() {
        StorageManager.shared.getUserFavouriteIDs(onSuccess: { [weak self] ids in
            self?.favouriteLocationIDs = ids
            self?.managedView?.reloadTableView()
        })
    }
    
    func location(at indexPath: IndexPath) -> Location? {
        return locations[safe: indexPath.row]
    }
    
    func locationTypeTitle(at indexPath: IndexPath) -> String? {
        let location = locations[safe: indexPath.row]
        let title = location?.getTitle(for: .type, inside: mainFilters)
        return title?.isEmptyOrWhitespace == false ? title : R.string.localizable.locationsDetailsNoData.localized()
    }
    
    func changeLocationStatus(at indexPath: IndexPath?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let indexPath = indexPath, let location = location(at: indexPath) else { return }
        let isFavouriteLocation = self.isFavouriteLocation(location: location)
        isFavouriteLocation ? removeFromFavourites(location: location, completion: completion) : addToFavourites(location: location, completion: completion)
    }
    
    func didSelectLocation(at indexPath: IndexPath) {
        guard let location = locations[safe: indexPath.row] else { return }
        navigation.toLocationDetails?(location)
    }
    
    func clearAllLocations() {
        locations.removeAll()
    }
    
    func showLocationList(searchText: String?, locationsReponse: LocationsResponse) {
        request = searchText
        self.locationsResponse = locationsReponse
        locations = locationsReponse.items ?? []
        managedView?.reloadTableView()
    }
    
    func showLocationDetails(location: Location) {
        navigation.toLocationDetails?(location)
    }
    
    func allLocationsAlreadyLoaded() -> Bool {
        guard let totalCount = locationsResponse?.total else { return false }
        return locations.count >= totalCount
    }
    
    func isFavouriteLocation(location: Location?) -> Bool {
        return favouriteLocationIDs.contains(where: { $0 == location?.id })
    }
    
    // MARK: - API
    
    func getLocations(by text: String?, completionHandler: (() -> Void)?) {
        request = text
        let offset = locations.count
        let language = LocalisationManager.shared.currentLanguage.rawValue
        let city = StorageManager.shared.currentCityId
        let filters = StorageManager.shared.filtersIdForLocations()
        let model = LocationConnectionParametersModel(text: text, offset: offset, city: city, language: language, filters: filters, mapLocationBounds: StorageManager.shared.mapLocationBounds, onlyCoordinateResults: false)
        let locationListConnection = GetLocationListConnection(parametersModel: model)
        APIClient.shared.start(connection: locationListConnection, successHandler: { [weak self] locationModel in
            self?.locationsResponse = locationModel
            guard let locations = locationModel.items else { return }
            self?.locations.append(contentsOf: locations)
            self?.managedView?.reloadTableView()
            completionHandler?()
            print(locations)
        }, failureHandler: { error in
            completionHandler?()
            print(error)
        })
    }
    
    func getFavouriteLocations(completion: @escaping (Result<Void, Error>) -> Void) {
        let offset = locations.count
        let connection = GetFavouritesLocationsConnection(language: LocalisationManager.shared.currentLanguage.rawValue, offset: offset)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] locationModel in
            self?.locationsResponse = locationModel
            guard let locations = locationModel.items else { return }
            self?.locations.append(contentsOf: locations)
            self?.managedView?.reloadTableView()
            completion(.success(()))
        }, failureHandler: {  error in
            completion(.failure(error))
        })
    }
    
    private func addToFavourites(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let connection = AddLocationToFavouritesConnection(id: location.id)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] _ in
            StorageManager.shared.appendToFavouritesLocation(id: location.id)
            self?.favouriteLocationIDs.append(location.id)
            completion(.success(()))
        }, failureHandler: {  error in
            completion(.failure(error))
        })
    }
    
    private func removeFromFavourites(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        let connection = RemoveLocationToFavouritesConnection(id: location.id)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] success in
            StorageManager.shared.removeFromFavouritesLocation(id: location.id)
            self?.favouriteLocationIDs.removeAll(where: { $0 == location.id })
            completion(.success(()))
        }, failureHandler: { error in
            completion(.failure(error))
        })
    }
    
    // MARK: - Error
    
    func errorTitle(for error: Error) -> String {
        let title: String
        switch error {
        case FavouritesError.forbidden:
            title = R.string.localizable.errorUserProfileForbidden.localized()
        case FavouritesError.update:
            title = R.string.localizable.errorFavouritesUpdate()
        case FavouritesError.objectID:
            title = R.string.localizable.errorFavouritesId()
        default:
            title = R.string.localizable.genericErrorUnknown.localized()
        }
        return title
    }
    
    // MARK: - Actions
    
    func backTapped() {
        isFavouriteState == true ? navigation.toUserProfile?() : navigation.toMap?()
    }
}
