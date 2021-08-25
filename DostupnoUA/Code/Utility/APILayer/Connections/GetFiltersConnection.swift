//
//  GetMapFiltersConnection.swift
//  DostupnoUA
//
//  Created by admin on 27.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Alamofire

struct GetFiltersConnection: Connection {
    
    typealias ReturnType = FiltersList
    
    var method: HTTPMethod = .get
    
    var path = "location-filter-objects/"
    
    var parameters: Parameters? {
        return ["lang": language]
    }
    let language: String
    
    var httpBody: Data?
    
    var headers: HTTPHeaders?
}
