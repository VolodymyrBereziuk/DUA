//
//  MapPresenter.swift
//  DostupnoUA
//
//  Created by admin on 26.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

protocol MapNavigation {
    var toFiltersList: (() -> Void)? { get set }
    var toLocationList: ((String?, LocationsResponse) -> Void)? { get set }
    var toLocationDetails: ((Location?) -> Void)? { get set }
    var toCreateLocation: (() -> Void)? { get set }
}

protocol MapViewProtocol: AnyObject {
    func setMarkersOnMap(markers: [MapMarker]?)
    func setCameraOnLocation(camera: GMSCameraPosition)
    func updateCameraToBounds(camera: GMSCameraUpdate)
    func clearMapView()
    func showAlerController(_ alertController: UIAlertController)
}

protocol MapPresenterProtocol: AnyObject {
    var managedView: MapViewProtocol? { get set }
    
    func viewDidLoad()
    func showFilters()
    func setCameraOnMyLocation()
    func setCameraOnLocation(coordinate: CLLocationCoordinate2D,
                             zoom: Float)
    func getLocations(coordinateBounds: LocationCoordinateBounds?,
                      searchText: String?,
                      onlyCoordinateResults: Bool)

    func didTapMyLocation()
    func showLocationList()
    func showLocationList(searchText: String?,
                          locationsReponse: LocationsResponse)
    func showLocationDetails(locationID: Int?)
    func showLocationDetails(location: Location)
    func showNewLocation()
}

class MapPresenter: MapPresenterProtocol {
    
    weak var managedView: MapViewProtocol?
    var navigation: MapNavigation
    var locationsResponse: LocationsResponse?
    var searchText: String?
    private var mainFilters: [MainFilter]?
    
    init(navigation: MapNavigation) {
        self.navigation = navigation
    }
    
    func viewDidLoad() {
        
        LocationManager.shared.authorizationHandler = { [weak self] success in
            if success {
                self?.setCameraOnMyLocation()
            }
        }
        StorageManager.shared.getFilters(onSuccess: { [weak self] filterList in
            self?.mainFilters = filterList.main
        })
        LocationManager.shared.checkIsServiceEnabled(completionHandler: { [weak self] isEnabled in
            if isEnabled {
                self?.setCameraOnMyLocation()
            } else {
                self?.setCameraOnCityLocation()
            }
        })

    }
    
    func showFilters() {
        navigation.toFiltersList?()
    }
    
    func showLocationList() {
        if let locationsResponse = locationsResponse {
            navigation.toLocationList?(searchText, locationsResponse)
        }
    }
    
    func showLocationDetails(locationID: Int?) {
        let location = locationsResponse?.items?.first(where: { $0.id == locationID })
        if let location = location {
            navigation.toLocationDetails?(location)
        }
    }
    
    func showLocationDetails(location: Location) {
        navigation.toLocationDetails?(location)
    }
    
    func showLocationList(searchText: String?, locationsReponse: LocationsResponse) {
        navigation.toLocationList?(searchText, locationsReponse)
    }
    
    func showNewLocation() {
        navigation.toCreateLocation?()
    }
    
    // MARK: - Actions
    
    func didTapMyLocation() {
        LocationManager.shared.checkIsServiceEnabled(completionHandler: { [weak self] isEnabled in
            if isEnabled {
                self?.setCameraOnMyLocation()
            } else {
                self?.showPermissionSettingsAlert()
            }
        })
    }
    
    func setCameraOnMyLocation() {
        if let currentLocation = LocationManager.shared.currentLocation {
            let coordinate = currentLocation.coordinate
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14.5)
            managedView?.setCameraOnLocation(camera: camera)
        }
    }
    
    func setCameraOnCityLocation() {
        guard
            let cityFilter = StorageManager.shared.firstDisplayedCityFilter,
            let location = cityFilter.displayedLocation
        else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: location.zoom)
        managedView?.setCameraOnLocation(camera: camera)
    }
    
    func setCameraOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoom)
        managedView?.setCameraOnLocation(camera: camera)
    }
    
    // MARK: - Prepare Markers
    
    private func setMarkersOnMap(locations: [Location]) {
        let markers = createMarkers(locations: locations)
        managedView?.setMarkersOnMap(markers: markers)
    }
    
    private func createMarkers(locations: [Location]) -> [MapMarker]? {
        var markers = [MapMarker]()
        for item in locations.enumerated() {
            let location = item.element
            let offset = item.offset
            guard let map = location.map, let lat = map.latitude, let lon = map.longitude, let latitude = Double(lat), let longitude = Double(lon) else { break }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let image = R.image.location()?.withRenderingMode(.alwaysTemplate)
            let typeTitle = location.getTitle(for: .type, inside: mainFilters)
            let marker = MapMarker(title: location.title, coordinate: coordinate, pinImage: image, color: location.getGradeColor(), locationId: location.id, locationTypeTitle: typeTitle, zIndex: offset)
            markers.append(marker)
        }
        return markers
        
    }
    
    func getLocations(coordinateBounds: LocationCoordinateBounds?,
                      searchText: String?,
                      onlyCoordinateResults: Bool) {
        
        let language = LocalisationManager.shared.currentLanguage.rawValue
        let city = StorageManager.shared.currentCityId
        let filters = StorageManager.shared.filtersIdForLocations()
        let model = LocationConnectionParametersModel(text: searchText,
                                                      city: city,
                                                      language: language,
                                                      filters: filters,
                                                      mapLocationBounds: StorageManager.shared.mapLocationBounds,
                                                      onlyCoordinateResults: onlyCoordinateResults)
        let locationListConnection = GetLocationListConnection(parametersModel: model)
        APIClient.shared.start(connection: locationListConnection, successHandler: { [weak self] locationModel in
            self?.locationsResponse = locationModel
            if let locations = self?.locationsResponse?.items {
                self?.managedView?.clearMapView()
                self?.setMarkersOnMap(locations: locations)
                
                let locationCoordinates = locations.map { ($0.map?.latitude, $0.map?.longitude) }

                if StorageManager.shared.mapLocationBounds?.isAllCoordinatesInside(coordinates: locationCoordinates) == false {
                    self?.updateCameraToMinMaxBounds(locations: locations)
                }
            }
            }, failureHandler: { [weak self] _ in
                self?.setMarkersOnMap(locations: [])
        })
    }
    
    func getSearchPlaces(by locations: [Location]) -> [SearchBarPlace] {
        let searchedPlaces = locations.map {
            return SearchBarPlace(id: $0.id, name: $0.title, gradeColor: $0.getGradeColor())
        }
        return searchedPlaces
    }
    
    private func updateCameraToMinMaxBounds(locations: [Location]) {
        
        let allLocationsCoordinates = locations.compactMap({ $0.map })
        let allLatitudes = allLocationsCoordinates.compactMap({ $0.latitude })
        let allLongitudes = allLocationsCoordinates.compactMap({ $0.longitude })
        
        guard
            let minLat = allLatitudes.min()?.toDouble(),
            let maxLat = allLatitudes.max()?.toDouble(),
            let minLon = allLongitudes.min()?.toDouble(),
            let maxLon = allLongitudes.max()?.toDouble()
            else { return }
        
        let minCoordinate = CLLocationCoordinate2D(latitude: minLat, longitude: minLon)
        let maxCoordinate = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
        let bounds = GMSCoordinateBounds(coordinate: minCoordinate, coordinate: maxCoordinate)
//        let camera = GMSCameraUpdate.fit(bounds)
          let cameraWithPadding = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
//        (will put inset the bounding box from the view's edge)
        
        managedView?.updateCameraToBounds(camera: cameraWithPadding)
    }
    
    func showPermissionSettingsAlert() {
        let title = R.string.localizable.permissionLocationTitle.localized()
        let message = R.string.localizable.permissionLocationDescription.localized()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let buttonTitle = R.string.localizable.permissionLocationButtonTitle.localized()
        let settingsAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
            }
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.genericCancel.localized(),
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        managedView?.showAlerController(alertController)
    }
}
