//
//  ConfigData.swift
//  DostupnoUA
//
//  Created by admin on 25.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class ConfigData: Codable {
    let version: ConfigVersion?
    
    init(version: ConfigVersion?) {
        self.version = version
    }
}

class ConfigVersion: Codable {
    
    let ios: String?
    
    init(ios: String?) {
        self.ios = ios
    }
}
