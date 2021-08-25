//
//  ClusterItem.swift
//  DostupnoUA
//
//  Created by Anton on 29.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class ClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var mapMarker: MapMarker
    
    init(mapMarker: MapMarker) {
        self.mapMarker = mapMarker
        self.position = mapMarker.coordinate
    }
}
