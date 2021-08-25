//
//  RestorePassword.swift
//  DostupnoUA
//
//  Created by Anton on 02.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct RestorePasswordConnection: Connection {
    
    typealias ReturnType = RegisterResponse
    
    var method: HTTPMethod = .post
    var path = "reset-password/"
    let email: String
    var parameters: Parameters? {
        var params = Parameters()
        params["email"] = email
        params["src_platform"] = "ios"
        return params
    }
    var httpBody: Data?
    var headers: HTTPHeaders?
}

enum RestorePasswordConnectionError: String, Error {
    case invalidEmail = "user_reset_password_invalid_email"
}

extension RestorePasswordConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return RestorePasswordConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
