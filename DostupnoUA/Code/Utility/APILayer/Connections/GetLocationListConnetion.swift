//
//  GetLocationListConnetion.swift
//  DostupnoUA
//
//  Created by admin on 06.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Alamofire

struct LocationCoordinateBounds {
    let minLat: Double
    let minLon: Double
    let maxLat: Double
    let maxLon: Double
    
    init(minLat: Double, minLon: Double, maxLat: Double, maxLon: Double) {
        self.minLat = minLat
        self.minLon = minLon
        self.maxLat = maxLat
        self.maxLon = maxLon
    }
    
    func isAllCoordinatesInside(coordinates: [(lat: String?, lon: String?)]) -> Bool {
        let transformedCoords = coordinates
            .compactMap { coords -> (Double, Double)? in
                if let lat = Double(coords.lat ?? ""), let lon = Double(coords.lon ?? "") {
                    return (lat, lon)
                }
                return nil
        }
        let firstCoord = transformedCoords.first { coord -> Bool in
            return minLat > coord.0 || maxLat < coord.0 || minLon > coord.1 || maxLon < coord.1
        }
        return firstCoord == nil
    }
}

struct LocationConnectionParametersModel {
    
    typealias FilterType = [String: [String]]
    
    let searchText: String?
    let postsPerPage: Int?
    let offset: Int?
    let city: String?
    var language: String?
    let filters: FilterType?
    let onlyCoordinateResults: Bool
    let mapLocationBounds: LocationCoordinateBounds?
    
    init(text: String? = nil,
         postsPerPage: Int? = nil,
         offset: Int? = nil,
         city: String? = nil,
         language: String?,
         filters: FilterType? = nil,
         mapLocationBounds: LocationCoordinateBounds?,
         onlyCoordinateResults: Bool) {
        searchText = text
        self.postsPerPage = postsPerPage
        self.offset = offset
        self.city = city
        self.language = language
        self.filters = filters
        self.mapLocationBounds = mapLocationBounds
        self.onlyCoordinateResults = onlyCoordinateResults
    }
    
}

struct GetLocationListConnection: Connection {
    
    typealias ReturnType = LocationsResponse
    
    var method: HTTPMethod = .get
    
    var path = "locations/"
    
    let parametersModel: LocationConnectionParametersModel?
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let value = parametersModel?.searchText, value.isEmptyOrWhitespace == false {
            params["sl"] = value
        }
        if let value = parametersModel?.postsPerPage {
            params["posts_per_page"] = value
        }
        if let value = parametersModel?.offset {
            params["offset"] = value
        }
        if let value = parametersModel?.city {
            params["city"] = value
        }
        if let value = parametersModel?.language {
            params["lang"] = value
        }
        if let onlyCoordinates = parametersModel?.onlyCoordinateResults, onlyCoordinates {
            params["only_coordinate_results"] = onlyCoordinates
        }
        if let coordinates = parametersModel?.mapLocationBounds {
            params["min_lat"] = coordinates.minLat
            params["min_lon"] = coordinates.minLon
            params["max_lat"] = coordinates.maxLat
            params["max_lon"] = coordinates.maxLon
        }
        
        parametersModel?.filters?
            .filter { $1.isEmpty == false }
            .forEach { key, value in
                params[key] = value.joined(separator: ",")
        }
        
        return params.isEmpty ? nil : params
    }
    
    var httpBody: Data?
    
    var headers: HTTPHeaders?
    
}
