//
//  LocationMapPositionPresenter.swift
//  DostupnoUA
//
//  Created by admin on 11.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol LocationMapPositionNavigation {
    var toLocationDetails: (() -> Void)? { get set }
}

protocol LocationMapPositionViewProtocol: AnyObject {
    func setMarkerOnMap(marker: MapMarker?)
    func setCameraOnLocation(camera: GMSCameraPosition)
    func reloadViewContent()
}

protocol LocationMapPositionPresenterProtocol: AnyObject {
    var managedView: LocationMapPositionViewProtocol? { get set }
    var navigationTitle: String? { get }

    func viewDidLoad()
    func setCameraOnMyLocation()
    func makeRoute(type: RouteType)
    func backTapped()
}

class LocationMapPositionPresenter: LocationMapPositionPresenterProtocol {
    
    weak var managedView: LocationMapPositionViewProtocol?
    var navigation: LocationMapPositionNavigation
    let location: Location?

    var navigationTitle: String? {
        return location?.title
    }
    
    init(navigation: LocationMapPositionNavigation, location: Location?) {
        self.navigation = navigation
        self.location = location
    }
    
    func viewDidLoad() {
        setMarkerOnMap()
    }
    
    func setCameraOnMyLocation() {
        if let currentLocation = LocationManager.shared.currentLocation {
            let coordinate = currentLocation.coordinate
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.5)
            managedView?.setCameraOnLocation(camera: camera)
        }
    }
    
    private func setCameraOnLocation(coordinate: CLLocationCoordinate2D, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoom)
        managedView?.setCameraOnLocation(camera: camera)
    }

    // MARK: - Prepare Markers
    
    private func setMarkerOnMap() {
        let marker = createMarker(location: location)
        managedView?.setMarkerOnMap(marker: marker)
        managedView?.reloadViewContent()
    }
    
    private func createMarker(location: Location?) -> MapMarker? {
        guard let map = location?.map, let lat = map.latitude, let lon = map.longitude, let latitude = Double(lat), let longitude = Double(lon) else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        setCameraOnLocation(coordinate: coordinate, zoom: 15.5)
        let image = R.image.location()?.withRenderingMode(.alwaysTemplate)
        let marker = MapMarker(title: location?.title, coordinate: coordinate, pinImage: image, color: location?.getGradeColor(), locationId: 0, locationTypeTitle: nil, zIndex: 0)
        return marker
    }
    
    // MARK: - Actions
    
    func backTapped() {
        navigation.toLocationDetails?()
    }
    
    func makeRoute(type: RouteType) {
        RouteManager.makeRoute(location: location, type: type)
    }
}
