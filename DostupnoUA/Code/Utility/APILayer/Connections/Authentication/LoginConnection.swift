//
//  AuthConnection.swift
//  DostupnoUA
//
//  Created by Anton on 08.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct LoginConnectionParametersModel {
    
    let email: String?
    let password: String?
    let type: SocialNetworkType?
    let fbToken: String?
    let gToken: String?
    let appleToken: String?

    internal init(email: String? = nil, password: String? = nil, type: SocialNetworkType?, fbToken: String? = nil, gToken: String? = nil, appleToken: String? = nil) {
        self.email = email
        self.password = password
        self.type = type
        self.fbToken = fbToken
        self.gToken = gToken
        self.appleToken = appleToken
    }
}

struct LoginConnection: Connection {
    
    typealias ReturnType = DostupnoToken
    
    var method: HTTPMethod = .post
    
    var path = "token/"
    
    let parametersModel: LoginConnectionParametersModel?
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let value = parametersModel?.email, value.isEmptyOrWhitespace == false {
            params["email"] = value
        }
        if let value = parametersModel?.password, value.isEmptyOrWhitespace == false {
            params["password"] = value
        }
        if let value = parametersModel?.type, value != .email {
            params["type"] = value.rawValue
        }
        if let value = parametersModel?.fbToken, value.isEmptyOrWhitespace == false {
            params["fb_token"] = value
        }
        if let value = parametersModel?.gToken, value.isEmptyOrWhitespace == false {
            params["g_token"] = value
        }
        if let value = parametersModel?.appleToken, value.isEmptyOrWhitespace == false {
            params["apple_token"] = value
        }
        params["src_platform"] = "ios"
        return params.isEmpty ? nil : params
    }
    
//    let language: String
    
    var httpBody: Data?
    
    var headers: HTTPHeaders?
}

enum LoginConnectionError: String, Error {
    case config = "jwt_auth_bad_config"
    case pendingUser = "jwt_auth_wp_pending_user"
    case email = "jwt_auth_bad_request_email"
    case password = "jwt_auth_bad_request_password"
    case incorrectPassword = "jwt_auth_bad_request_incorrect_password"
    case fbToken = "jwt_auth_bad_request_fb_token_error"
    case googleToken = "jwt_auth_bad_request_google_token_error"
    case appleToken = "jwt_auth_bad_request_apple_token_error"
    case wrongAuthMethod = "jwt_auth_bad_request_wrong_auth_method"
}

extension LoginConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return LoginConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
