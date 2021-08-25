//
//  Connection+DostupnoError.swift
//  DostupnoUA
//
//  Created by admin on 12.10.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

enum GlobalAPIError: String, Error {
    case unknownError
    case serverError = "server_error"
    case responseDataIsNil
}

enum ErrorParsingResult {
    case globalError(GlobalAPIError)
    case errorCode(String)
}

extension Connection {
    // Format of errors
    //    {
    //        "code": "comments_are_not_allowed",
    //        "message": "Comments are not allowed for this post or post was not specified",
    //        "data": {
    //            "status": 403
    //        }
    //    }
    
    func getErrorResult(from data: Data?) -> ErrorParsingResult {
        guard
            let data = data,
            let errorContent = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let code = errorContent["code"] as? String
            else {
            return .globalError(GlobalAPIError.unknownError)
        }
        if let globalError = GlobalAPIError(rawValue: code) {
            return .globalError(globalError)
        }
        
        return .errorCode(code)
    }
}
