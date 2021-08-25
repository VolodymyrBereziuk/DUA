//
//  GetConfigConnection.swift
//  DostupnoUA
//
//  Created by admin on 25.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct GetConfigConnection: Connection {
    
    typealias ReturnType = ConfigData
    
    var method: HTTPMethod = .get
    
    var path = "apps-config"
    
    var parameters: Parameters?
    
    var httpBody: Data?
    
    var headers: HTTPHeaders?
}
