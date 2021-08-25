//
//  UserProfile.swift
//  DostupnoUA
//
//  Created by Anton on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class UserProfile: Codable {
    
    let id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var tel: String?
    var city: String?
    let savedLocations: [String]?
    let savedArticles: [String]?
    let isVolunteer: Bool?
    let photo: String?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case city = "user_city"
        case id, email, tel, photo, language
        case savedLocations = "saved_locations"
        case savedArticles = "saved_articles"
        case isVolunteer = "is_volunteer"
    }
}
