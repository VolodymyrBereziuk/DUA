//
//  RequestInterceptor.swift
//  DostupnoUA
//
//  Created by Anton on 25.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire

class RequestInterceptor: Alamofire.RequestInterceptor {
    
    private var refreshTokenUrlSuffix: String?
    private let unauthorizedStatusCode = 401
    
    private var logoutAction: (() -> Void)?
    
    init(logoutAction: (() -> Void)?) {
        self.logoutAction = logoutAction
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest

        if !isRefreshTokenRequest(urlRequest: urlRequest) {
            if let token = PersistenceManager.manager.dostupnoToken?.token {
                let authorizationHeader = HTTPHeader.authorization("")//"Authorization"
                if urlRequest.headers.contains(where: { $0.name == authorizationHeader.name }) {
                    urlRequest.headers.update(.authorization(bearerToken: token))
                }
            }
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        print("\(#function) : request : \(request), retryCount : \(request.retryCount)")

        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == unauthorizedStatusCode else {
            return completion(.doNotRetryWithError(error))
        }
        if isRefreshTokenRequest(urlRequest: request.request) {
            DispatchQueue.main.async {
                self.logoutAction?()
            }
            return completion(.doNotRetryWithError(error))
        }
        refreshToken(successHandler: { token in
            PersistenceManager.manager.dostupnoToken = token
            completion(.retry)
        }, failureHandler: { error in
            completion(.doNotRetryWithError(error))
        })
    }
    
    private func refreshToken(successHandler: @escaping ((DostupnoToken) -> Void), failureHandler: @escaping ((_ error: Error) -> Void)) {
        let connection = RefreshTokenConnection()
        refreshTokenUrlSuffix = connection.path
        APIClient.shared.start(connection: connection, successHandler: successHandler, failureHandler: failureHandler)
    }
    
    // MARK: - Utils
    
    private func isRefreshTokenRequest(urlRequest: URLRequest?) -> Bool {
        if let urlSuffix = refreshTokenUrlSuffix, urlRequest?.url?.absoluteString.hasSuffix(urlSuffix) == true {
            return true
        }
        return false
    }
}
