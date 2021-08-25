//
//  MapMarker.swift
//  DostupnoUA
//
//  Created by Anton on 09.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

struct MapMarker {
    var title: String?
//    var description: String?
    var coordinate: CLLocationCoordinate2D
    var pinImage: UIImage?
    var color: UIColor?
    var locationId: Int
    var locationTypeTitle: String?
    var zIndex: Int
}
