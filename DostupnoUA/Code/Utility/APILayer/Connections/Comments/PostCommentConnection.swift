//
//  PostCommentConnection.swift
//  DostupnoUA
//
//  Created by admin on 01.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

enum AddCommentError: String, Error {
    case notAuthorized = "not_authorized"
    case commentsAreNotAllowed = "comments_are_not_allowed"
    case commentIsEmpty = "comment_is_empty"
    case commentParentIsInvalid = "comment_parent_is_invalid"
}

struct AddCommentConnection: Connection {
    
    let locationId: Int
    let content: String
    
    typealias ReturnType = Int
    
    var method: HTTPMethod = .post
    var path = "add-comment/"
    
    var parameters: Parameters? {
        var params = Parameters()
        params["post_id"] = locationId
        params["content"] = content
        return params.isEmpty ? nil : params
    }

    var httpBody: Data?
    
    //TODO: don't use singleton here, we need to send token here
    var headers: HTTPHeaders? {
        var params = HTTPHeaders()
        if let dostupnoToken = PersistenceManager.manager.dostupnoToken,
            let bearerToken = dostupnoToken.bearerValue {
            params.add(name: "Authorization", value: bearerToken)
        }
        return params
    }
    
    func parseIfError(data: Data?) -> Error {
        let result = getErrorResult(from: data)
        switch result {
        case .globalError(let globalError):
            return globalError
        case .errorCode(let code):
            return AddCommentError(rawValue: code) ?? GlobalAPIError.unknownError
        }
    }
}
