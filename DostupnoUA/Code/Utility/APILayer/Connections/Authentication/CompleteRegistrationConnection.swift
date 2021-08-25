//
//  CompleteRegistrationConnection.swift
//  DostupnoUA
//
//  Created by admin on 14.10.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct CompleteRegistrationParametersModel {
    
    let email: String?
    let key: String?
    
    init(email: String?, key: String?) {
        self.email = email
        self.key = key
    }
}

struct CompleteRegistrationConnection: Connection {
    
    typealias ReturnType = DostupnoToken
    
    var method: HTTPMethod = .post
    
    var path = "complete-registration/"
    
    let parametersModel: CompleteRegistrationParametersModel?
    
    var parameters: Parameters? {
        var params = Parameters()
        
        if let value = parametersModel?.email, value.isEmptyOrWhitespace == false {
            params["email"] = value
        }
        if let value = parametersModel?.key, value.isEmptyOrWhitespace == false {
            params["key"] = value
        }
        params["src_platform"] = "ios"
        
        return params.isEmpty ? nil : params
    }
        
    var httpBody: Data?
    
    var headers: HTTPHeaders?
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return CompleteRegistrationError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}

enum CompleteRegistrationError: String, Error {
    case wrongKey = "user_complete_registration_wrong_key"
    case invalidEmail = "user_complete_registration_invalid_email"
}
