//
//  GetCommentsConnection.swift
//  DostupnoUA
//
//  Created by admin on 01.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

struct GetCommentsConnection: Connection {    
    
    typealias ReturnType = [Comment]
    
    var method: HTTPMethod = .get
    
    var path: String {
        return "get-comments-by-post-id/"
    }
    
    var parameters: Parameters? {
        var params = Parameters()
        params["post_id"] = postId
        if let offset = offset {
            params["offset"] = offset
        }
        return params
    }
    
    let postId: Int
    let offset: Int?
    
    var httpBody: Data?
    
    var headers: HTTPHeaders?
}

enum GetCommentsConnectionError: String, Error {
    case emptyPostId = "empty_post_id"
}

extension GetCommentsConnection {
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return GetCommentsConnectionError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
