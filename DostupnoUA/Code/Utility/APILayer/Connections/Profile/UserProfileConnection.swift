//
//  UserProfileConnection.swift
//  DostupnoUA
//
//  Created by Anton on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct UserProfileConnection: Connection {
    
    typealias ReturnType = UserProfile
    
    var method: HTTPMethod = .get
    var path = "profile/"
    var parameters: Parameters?
//    let language: String
    var httpBody: Data?
    
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
            let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
}

enum UserProfileConnectionError: String, Error {
    case notLoggedInUser = "not_logged_in_user"
    case forbidden = "forbidden"
}

extension UserProfileConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return UserProfileConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
