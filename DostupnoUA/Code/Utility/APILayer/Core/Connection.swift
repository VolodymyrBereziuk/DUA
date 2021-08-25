//
//  Connection.swift
//  OpenWeatherMap
//
//  Created by admin on 6/16/19.
//  Copyright © 2019 Viktor Drykin. All rights reserved.
//

import Alamofire
import Foundation

public typealias Parameters = [String: Any]

protocol Connection {
    associatedtype ReturnType: Decodable

    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var httpBody: Data? { get }
    var headers: HTTPHeaders? { get }
    
    var isMultipartFormData: Bool? { get }
    
    //var isNeededApiKey: Bool { get }

    func parse(data: Data) throws -> ReturnType
    func parseIfError(data: Data?) -> Error
}

extension Connection {
    
    var isMultipartFormData: Bool? {
        return false
    }
    
    func parse(data: Data) throws -> ReturnType {
        do {
            let decodedData = decodeHtmlEntites(data: data)
            let response = try JSONDecoder.dateSince1970.decode(ReturnType.self, from: decodedData)
            return response
        }
    }
    
    func parseIfError(data: Data?) -> Error {
        switch getErrorResult(from: data) {
        case .globalError(let error):
            return error
        case .errorCode:
            return GlobalAPIError.unknownError
        }
    }
    
    //for correct backend can be removed
    private func decodeHtmlEntites(data: Data) -> Data {
        let convertedString = String(data: data, encoding: String.Encoding.utf8)
        return convertedString?.htmlDecoded.data(using: .utf8) ?? data
    }
}
