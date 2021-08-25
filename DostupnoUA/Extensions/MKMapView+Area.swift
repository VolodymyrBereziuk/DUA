//
//  MKMapView+Area.swift
//  OpenWeatherMap
//
//  Created by Viktor Drykin on 23.03.2018.
//  Copyright © 2018 Viktor Drykin. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    func setMapVisibleArea(lat: Double, lng: Double, visibility: Int) {
        let center = CLLocationCoordinate2DMake(lat, lng)
        let distance = Double(visibility)
        let mapRegion = MKCoordinateRegion(center: center, latitudinalMeters: distance, longitudinalMeters: distance)
        setRegion(mapRegion, animated: false)
        setCenter(center, animated: false)
    }
}
