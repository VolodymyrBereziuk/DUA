//
//  RefreshTokenConnection.swift
//  DostupnoUA
//
//  Created by admin on 14.10.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct RefreshTokenConnection: Connection {
    
    typealias ReturnType = DostupnoToken
    
    var method: HTTPMethod = .post
    
    var path = "token/refresh/"
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
            let refreshToken = dostupnoToken.refreshToken {
            params["refresh_token"] = refreshToken
        }
        return params.isEmpty ? nil : params
    }
    var httpBody: Data?
    var headers: HTTPHeaders?
}

enum RefreshTokenConnectionError: String, Error {
    case config = "jwt_auth_bad_config"
    case badRequest = "jwt_auth_bad_request_refresh_token"
    case badISS = "jwt_auth_bad_iss"
    case userIdIsNotFoundForToken = "jwt_auth_bad_request"
    case invalidUserToken = "jwt_auth_bad_request_invalid_user_token"
    case invalidToken = "jwt_auth_invalid_token"
}

extension RefreshTokenConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return RefreshTokenConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
