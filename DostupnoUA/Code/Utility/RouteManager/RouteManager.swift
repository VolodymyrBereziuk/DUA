//
//  RouteManager.swift
//  DostupnoUA
//
//  Created by Anton on 12.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation
import MapKit

struct RouteManager {
        
    static func makeRoute(location: Location?, type: RouteType) {
        guard let map = location?.map, let lat = map.latitude, let lon = map.longitude, let latitude = Double(lat), let longitude = Double(lon) else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        switch type {
        case .apple:
            makeAppleRoute(coordinate: coordinate, title: location?.title)
        case .google:
            makeGoogleRoute(coordinate: coordinate)
        }
    }
    
    private static func makeAppleRoute(coordinate: CLLocationCoordinate2D, title: String?) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
    }
    
    private static func makeGoogleRoute(coordinate: CLLocationCoordinate2D) {
        guard let url = URL(string: "comgooglemaps://") else { return }
        if UIApplication.shared.canOpenURL(url) {
            let urlString = "http://maps.google.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)"
            guard let googleUrl = URL(string: urlString) else { return }
            UIApplication.shared.open(googleUrl, options: [:], completionHandler: nil)
        }
    }
    
}
