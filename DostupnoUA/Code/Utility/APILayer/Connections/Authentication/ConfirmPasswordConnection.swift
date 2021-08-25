//
//  ConfirmPasswordConnection.swift
//  DostupnoUA
//
//  Created by admin on 14.10.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct ConfirmPasswordParametersModel {
    
    let email: String?
    let key: String?
    let newPassword: String?
    
    init(email: String?, key: String?, newPassword: String?) {
        self.email = email
        self.key = key
        self.newPassword = newPassword
    }
}

struct ConfirmPasswordConnection: Connection {
    
    typealias ReturnType = DostupnoToken
    
    var method: HTTPMethod = .post
    
    var path = "confirm-password/"
    
    let parametersModel: ConfirmPasswordParametersModel?
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let value = parametersModel?.email, value.isEmptyOrWhitespace == false {
            params["email"] = value
        }
        if let value = parametersModel?.key, value.isEmptyOrWhitespace == false {
            params["key"] = value
        }
        if let value = parametersModel?.newPassword, value.isEmptyOrWhitespace == false {
            params["password"] = value
        }
        params["src_platform"] = "ios"
        
        return params.isEmpty ? nil : params
    }
        
    var httpBody: Data?
    
    var headers: HTTPHeaders?
}

enum ConfirmPasswordError: String, Error {
    case emptyPassword = "user_confirm_password_empty_password"
    case weakPassword = "user_confirm_password_weak_password"
    case wrongKey = "user_confirm_password_wrong_key"
    case invalidEmail = "user_confirm_password_invalid_email"
}

extension ConfirmPasswordConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return ConfirmPasswordError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
