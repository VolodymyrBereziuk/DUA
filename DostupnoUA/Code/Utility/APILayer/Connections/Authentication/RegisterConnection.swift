//
//  RegisterConnection.swift
//  DostupnoUA
//
//  Created by Anton on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct RegisterConnectionParametersModel {
    
    let email: String?
    let pass: String?
    let name: String?
    let forceLogin: Bool? = false
    
    init(email: String?, pass: String?, name: String?) {
        self.email = email
        self.pass = pass
        self.name = name
    }
}

class RegisterResponse: Codable {
    
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case success
    }
}

struct RegisterConnection: Connection {
    
    typealias ReturnType = RegisterResponse
    
    var method: HTTPMethod = .post
    
    var path = "register/"
    
    let parametersModel: RegisterConnectionParametersModel?
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let value = parametersModel?.name, value.isEmptyOrWhitespace == false {
            params["name"] = value
        }
        if let value = parametersModel?.pass, value.isEmptyOrWhitespace == false {
            params["pass"] = value
        }
        if let value = parametersModel?.forceLogin {
            params["force_login"] = value
        }
        if let value = parametersModel?.email, value.isEmptyOrWhitespace == false {
            params["email"] = value
        }
        params["src_platform"] = "ios"
        params["locale"] = Locale.current.identifier //Допустимые значения: "uk_UA", "en_US"

        return params.isEmpty ? nil : params
    }

    var httpBody: Data?
    
    var headers: HTTPHeaders?
}

extension RegisterConnection {
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return RegisterConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}

enum RegisterConnectionError: String, Error {
    case nameIsEmpty = "user_register_empty_name "
    case invalidEmail = "user_register_invalid_email"
    case userExists = "user_register_user_exist"
    case emptyPassword = "user_register_empty_pass"
    case weakPassword = "user_register_weak_pass"
    case badConfig = "jwt_auth_bad_config"
    case badRequestEmail = "jwt_auth_bad_request_email"
    case badRequestPassword = "jwt_auth_bad_request_password"
    case badRequestFbToken = "jwt_auth_bad_request_fb_token_error"
    case googleToken = "jwt_auth_bad_request_google_token_error"
    case appleToken = "jwt_auth_bad_request_apple_token_error"
    case fbToken = "fb_token_error"
}
