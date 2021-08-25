//
//  DostupnoToken.swift
//  DostupnoUA
//
//  Created by Anton on 08.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class DostupnoToken: Codable {
    
    let token: String?
    let refreshToken: String?
    let expiration: Double?
    let isNewUser: Int?
    
    enum CodingKeys: String, CodingKey {
        case token
        case refreshToken = "refresh_token"
        case expiration
        case isNewUser = "is_new_user"
    }

}
