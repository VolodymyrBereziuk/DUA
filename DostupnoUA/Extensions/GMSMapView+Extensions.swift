//
//  GMSMapView+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 26.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import GoogleMaps

extension GMSMapView {

    func initMapStyle() {
        let styleURL = Bundle.main.url(forResource: "googleMapStyle", withExtension: "json")
        if let styleURL = styleURL {
            mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
    }
    
    var locationCoordinateBounds: LocationCoordinateBounds {
        let visibleRegion = self.projection.visibleRegion()
        
        let minLat = min(visibleRegion.nearLeft.latitude, visibleRegion.nearRight.latitude, visibleRegion.farLeft.latitude, visibleRegion.farRight.latitude)
        let maxLat = max(visibleRegion.nearLeft.latitude, visibleRegion.nearRight.latitude, visibleRegion.farLeft.latitude, visibleRegion.farRight.latitude)
        let minLon = min(visibleRegion.nearLeft.longitude, visibleRegion.nearRight.longitude, visibleRegion.farLeft.longitude, visibleRegion.farRight.longitude)
        let maxLon = max(visibleRegion.nearLeft.longitude, visibleRegion.nearRight.longitude, visibleRegion.farLeft.longitude, visibleRegion.farRight.longitude)
        
        return LocationCoordinateBounds(minLat: minLat, minLon: minLon, maxLat: maxLat, maxLon: maxLon)
    }
}
