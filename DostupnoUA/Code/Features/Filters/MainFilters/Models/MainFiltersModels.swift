//
//  MainFiltersModels.swift
//  DostupnoUA
//
//  Created by admin on 19.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

struct CityModel {
    var name: String?
    var id: String
}

struct MainFiltersModel {
    let imageName: String?
    var name: String?
    let isSelected: Bool
}
