//
//  FavoritesConnection.swift
//  DostupnoUA
//
//  Created by Anton on 13.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct StatusResponse: Codable {
    
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success
    }
}

enum FavouritesError: String, Error {
    case forbidden = "forbidden"
    case update = "wishlist_update_error"
    case objectID = "wishlist_object_id_error"
}

struct GetFavouritesLocationsConnection: Connection {
    
    typealias ReturnType = LocationsResponse
    
    var method: HTTPMethod = .get
    var path = "wishlist/"
    let language: String?
    let offset: Int?
    var httpBody: Data?
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
           let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
    
    var parameters: Parameters? {
        var params = Parameters()
        if let value = language {
            params["lang"] = value
        }
        if let value = offset {
            params["offset"] = value
        }
        return params
    }
    
}

struct GetFavouritesLocationsIDsConnection: Connection {
    
    typealias ReturnType = [Int]
    
    var method: HTTPMethod = .get
    var path = "wishlist-ids/"
    let language: String
    var httpBody: Data?
    
    var parameters: Parameters? {
        var params = Parameters()
        params["lang"] = language
        return params
    }
    
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
           let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
    
}

struct AddLocationToFavouritesConnection: Connection {
    
    typealias ReturnType = Bool
    
    var method: HTTPMethod = .post
    var path = "wishlist_add/"
    let id: Int
    let language: String? = LocalisationManager.shared.currentLanguage.rawValue
    var httpBody: Data?
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
           let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
    
    var parameters: Parameters? {
        var params = Parameters()
        params["id"] = id
        if let value = language {
            params["lang"] = value
        }
        return params
    }
}

struct RemoveLocationToFavouritesConnection: Connection {
    
    typealias ReturnType = Bool
    
    var method: HTTPMethod = .post
    var path = "wishlist_remove/"
    let id: Int
    let language: String? = LocalisationManager.shared.currentLanguage.rawValue
    var httpBody: Data?
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
           let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
    
    var parameters: Parameters? {
        var params = Parameters()
        params["id"] = id
        if let value = language {
            params["lang"] = value
        }
        return params
    }
}

extension GetFavouritesLocationsIDsConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return FavouritesError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}

extension AddLocationToFavouritesConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return FavouritesError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}

extension RemoveLocationToFavouritesConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return FavouritesError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
