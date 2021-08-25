//
//  APIClient.swift
//  OpenWeatherMap
//
//  Created by admin on 6/16/19.
//  Copyright © 2019 Viktor Drykin. All rights reserved.
//

import Alamofire
import Foundation

class APIClient {
    
    static var interceptor: RequestInterceptor?
    private let interceptor: RequestInterceptor?
    
    static let shared: APIClient = {
        let instance = APIClient(interceptor: interceptor)
        return instance
    }()
    
    private init(interceptor: RequestInterceptor?) {
        guard let interceptor = interceptor else {
            fatalError("Error - you must set interceptor before used shared")
        }
        self.interceptor = interceptor
    }
    
    func start<C: Connection>(connection: C, successHandler: @escaping ((C.ReturnType) -> Void), failureHandler: @escaping ((_ error: Error) -> Void)) {
        if connection.isMultipartFormData == true {
            multipartRequest(connection: connection, successHandler: successHandler, failureHandler: failureHandler)
        } else {
            genericRequest(connection: connection, successHandler: successHandler, failureHandler: failureHandler)
        }
    }
    
    private func multipartRequest<C: Connection>(connection: C, successHandler: @escaping ((C.ReturnType) -> Void), failureHandler: @escaping ((_ error: Error) -> Void)) {
        let url = APIEnvironment.configureUrlPath(with: connection.path)
        
        guard let urlRequest = try? URLRequest(url: url, method: connection.method, headers: connection.headers) else { return }
        
        let request = AF.upload(multipartFormData: { multiPart in
            guard let params = connection.parameters else { return }
            for (key, value) in params {
                var isImage = false
                var data: Data?
                switch value {
                case let intValue as Int:
                    data = "\(intValue)".data(using: .utf8)
                case let stringValue as String:
                    data = stringValue.data(using: .utf8)
                case let imageValue as UIImage:
                    data = imageValue.pngData()
                    isImage = true
                default:
                    break
                }
                guard let unwrappedData = data else { return }
                if isImage {
                    multiPart.append(unwrappedData, withName: "photo", fileName: "photo.png", mimeType: "image/png")
                } else {
                    multiPart.append(unwrappedData, withName: key)
                }
            }
        }, with: urlRequest, interceptor: interceptor)
        request.validate().response { [weak self] response in
            self?.parseResponse(connection: connection, response: response, successHandler: successHandler, failureHandler: failureHandler)
        }
    }
    
    private func genericRequest<C: Connection>(connection: C, successHandler: @escaping ((C.ReturnType) -> Void), failureHandler: @escaping ((_ error: Error) -> Void)) {
        let url = APIEnvironment.configureUrlPath(with: connection.path)
        
        let request = AF.request(url, method: connection.method, parameters: connection.parameters, encoding: URLEncoding.default, headers: connection.headers, interceptor: interceptor).validate()
        request.response { [weak self] response in
            self?.parseResponse(connection: connection, response: response, successHandler: successHandler, failureHandler: failureHandler)
        }
    }
    
    private func parseResponse<C: Connection>(connection: C, response: AFDataResponse<Data?>, successHandler: @escaping ((C.ReturnType) -> Void), failureHandler: @escaping ((_ error: Error) -> Void)) {
        
        if response.error != nil {
            let handledError = connection.parseIfError(data: response.data)
            failureHandler(handledError)
            return
        }
        
        guard let data = response.data else {
            failureHandler(GlobalAPIError.responseDataIsNil)
            return
        }
        
        do {
            #if DEBUG
            debugPrint(data: data)
            #endif
            let result = try connection.parse(data: data)
            successHandler(result)
        } catch {
            failureHandler(error)
        }
    }
    
    private func debugPrint(data: Data) {
        let convertedString = String(data: data, encoding: .utf8)
        if let json = convertedString {
            print(">>>>>>>DEBUG JSON RESPONSE \n", json as Any)
        } else {
            print(">>>>>>>DEBUG CANNOT CONVERT TO JSON!!!!")
        }
    }
}
