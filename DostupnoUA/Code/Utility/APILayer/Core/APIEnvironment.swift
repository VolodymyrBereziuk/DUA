//
//  APIEnvironment.swift
//  OpenWeatherMap
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 Viktor Drykin. All rights reserved.
//

import Foundation

struct APIEnvironment {
    
    static var endPoint =
    //"https://preprod.dev.dostupnoua.org/wp-json/api/v1/"
        
    "https://map.dostupno.ua/wp-json/api/v1/"

    static func configureUrlPath(with path: String) -> String {
        return endPoint + path
    }
}
