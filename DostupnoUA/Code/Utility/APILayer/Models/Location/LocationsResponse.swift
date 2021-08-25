//
//  Location.swift
//  DostupnoUA
//
//  Created by admin on 27.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

class LocationsResponse: Codable {
    let items: [Location]?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case items, total
    }
}

class Location: Codable {
    
    let id: Int
    let title: String
    let type: String?
    let link: String?
    
    let publishDate: Date?
    
    let thumbnail: Thumbnail?
    
    let generalInfoText: String?
    let generalGrade: String?
    
    let cityFilter: [String]?
    
    let mapAddressText: String?
    let mapAddress: String?
    let map: Coordinate?
    
    let dostupnoRecommendsGrade: String?
    let dostupnoRecommendsText: String?
    let dostupnoRecommendsFilter: [String]?
    
    let bikeParkingText: String?
    //let bikeParkingFilter: [String]?
    let bikeParkingGrade: String?
    
    let petsText: String?
    let petsFilter: [String]?
    let petsGrade: String?
    
    let enterGrade: String?
    let enterText: String?
    let enterWidth: String?
    let enterHandrailsHeight: String?
    let enterDoorstepHeight: String?
    let enterFilter: [String]?
    let enterPhotos: [Photo]?
    
    let bathroomGrade: String?
    let bathroomText: String?
    let bathroomWidth: String?
    let bathroomFilter: [String]?
    let bathroomPhotos: [Photo]?
    
    let indoorGrade: String?
    let indoorText: String?
    let indoorFilter: [String]?
    let indoorPhotos: [Photo]?
    
    let stuffGrade: String?
    let stuffText: String?
    let stuffFilter: [String]?
    
    let parkingGrade: String?
    let parkingText: String?
    let parkingFilter: [String]?
    
    let childGrade: String?
    let childText: String?
    let childFilter: [String]?
    let childPhotos: [Photo]?
    
    let brailleGrade: String?
    let brailleText: String?
    let brailleFilter: [String]?
    
    let typeFilter: [String]?
    let commentsOpen: Int?
    var isCommentsAvailable: Bool { commentsOpen?.isTrue ?? false }
    
    enum CodingKeys: String, CodingKey {
        case id, title, type, link
        case publishDate = "publish_date"
        case thumbnail
        
        case generalInfoText = "general_info_text"
        case generalGrade = "general_grade"
        
        case cityFilter = "city_filter"
        
        case mapAddressText = "map_address_text"
        case mapAddress = "map_address"
        case map = "map"
        
        case dostupnoRecommendsGrade = "available_recommended_grade"
        case dostupnoRecommendsText = "available_recommended_text"
        case dostupnoRecommendsFilter = "available_recommended_filter"
        
        case bikeParkingText = "bike_parking_text"
        //case bikeParkingFilter = "bike_parking_exist"
        case bikeParkingGrade = "bike_parking_grade"
        
        case petsText = "pets_text"
        case petsFilter = "pets_allowed"
        case petsGrade = "pets_grade"
        
        case enterGrade = "enter_grade"
        case enterText = "enter_text"
        case enterWidth = "enter_width"
        case enterHandrailsHeight = "enter_handrails_height"
        case enterDoorstepHeight = "enter_doorstep_height"
        case enterFilter = "enter_filter"
        case enterPhotos = "enter_photos"
        
        case bathroomGrade = "bathroom_grade"
        case bathroomText = "bathroom_text"
        case bathroomWidth = "bathroom_width"
        case bathroomFilter = "bathroom_filter"
        case bathroomPhotos = "bathroom_photos"
        
        case indoorGrade = "indoor_grade"
        case indoorText = "indoor_text"
        case indoorFilter = "indoor_filter"
        case indoorPhotos = "indoor_photos"
        
        case stuffGrade = "stuff_grade"
        case stuffText = "stuff_text"
        case stuffFilter = "stuff_filter"
        
        case parkingGrade = "parking_grade"
        case parkingText = "parking_text"
        case parkingFilter = "parking_filter"
        
        case childGrade = "child_grade"
        case childText = "child_text"
        case childFilter = "child_filter"
        case childPhotos = "child_photos"
        
        case brailleGrade = "braille_grade"
        case brailleText = "braille_text"
        case brailleFilter = "braille_filter"
        
        case typeFilter = "type_filter"
        case commentsOpen = "comments_open"
    }
    
    class Photo: Codable {
        
        let id: Int
        let name: String?
        let alt: String?
        let url: String?
        let width: Int?
        let height: Int?
        let sizes: Sizes?
        let caption: String?
        
        init(id: Int, name: String?, alt: String?, url: String?, width: Int?, height: Int?, sizes: Sizes?, caption: String?) {
            self.id = id
            self.name = name
            self.alt = alt
            self.url = url
            self.width = width
            self.height = height
            self.sizes = sizes
            self.caption = caption
        }
    }
    
    class Coordinate: Codable {
        
        let latitude: String?
        let longitude: String?
        let zoom: String?
        
        enum CodingKeys: String, CodingKey {
            case latitude, longitude, zoom
        }
    }
}
