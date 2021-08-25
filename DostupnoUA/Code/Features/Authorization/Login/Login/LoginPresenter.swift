//
//  LoginPresenter.swift
//  DostupnoUA
//
//  Created by admin on 21.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case tokenNil
}

protocol LoginNavigation {
    var toRegistration: (() -> Void)? { get set }
    var toLoginEmail: (() -> Void)? { get set }
    var toUserProfile: (() -> Void)? { get set }
    var toRestorePassword: (() -> Void)? { get set }
}

protocol LoginViewProtocol: AnyObject {
    func showError(_ error: Error)
}

protocol LoginPresenterProtocol {
    var managedView: LoginViewProtocol? { get set }
    
    func toLoginEmail()
    func toRegistration()
    func login(token: String, typeSocial: SocialNetworkType, completion: @escaping (Result<Void, Error>) -> Void)
    func errorTitle(from error: Error) -> String
}

protocol LoginEmailPresenterProtocol {
    func toRegistration()
    func toRestorePassword()
    func login(email: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void)
    func errorTitle(from error: Error) -> String
}

class LoginPresenter: LoginPresenterProtocol, LoginEmailPresenterProtocol {
    
    weak var managedView: LoginViewProtocol?

    let navigation: LoginNavigation

    init(navigation: LoginNavigation) {
        self.navigation = navigation
    }
    
    func toLoginEmail() {
        navigation.toLoginEmail?()
    }
    
    func toRegistration() {
        navigation.toRegistration?()
    }

    // MARK: - API
    
    func login(token: String, typeSocial: SocialNetworkType, completion: @escaping (Result<Void, Error>) -> Void) {
        var model: LoginConnectionParametersModel?
        switch typeSocial {
        case .apple:
            model = LoginConnectionParametersModel(type: typeSocial, appleToken: token)
        case .facebook:
            model = LoginConnectionParametersModel(type: typeSocial, fbToken: token)
        case .google:
            model = LoginConnectionParametersModel(type: typeSocial, gToken: token)
        case .email:
            break
        }
        login(loginConnection: LoginConnection(parametersModel: model), completion: completion)
    }
    
    func login(email: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let model = LoginConnectionParametersModel(email: email, password: password, type: .email)
        login(loginConnection: LoginConnection(parametersModel: model), completion: completion)
    }
    
    private func login(loginConnection: LoginConnection, completion: @escaping (Result<Void, Error>) -> Void) {
        APIClient.shared.start(connection: loginConnection, successHandler: { [weak self] token in
            guard token.token != nil else {
                completion(.failure(LoginError.tokenNil))
                return
            }
            PersistenceManager.manager.dostupnoToken = token
            self?.getUserProfile(completion: completion)
        }, failureHandler: { error in
            completion(.failure(error))
        })
    }
    
    private func getUserProfile(completion: @escaping (Result<Void, Error>) -> Void) {
        StorageManager.shared.getUserProfile(language: LocalisationManager.shared.currentLanguage.rawValue,
                                             onSuccess: { [weak self] _ in
                                                self?.getUserFavouriteIDs()
                                                completion(.success(()))
                                                self?.navigation.toUserProfile?()
            },
                                             onFailure: { error in
                                                completion(.failure(error))
        })
    }
    
    private func getUserFavouriteIDs() {
        StorageManager.shared.getUserFavouriteIDs(forceDownload: true, onSuccess: { _ in
        }, onFailure: { _ in
        })
    }
    
    func toRestorePassword() {
        navigation.toRestorePassword?()
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func errorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case UserProfileConnectionError.notLoggedInUser:
            message = R.string.localizable.errorUserProfileNotLoggedInUser.localized()
        case UserProfileConnectionError.forbidden:
            message = R.string.localizable.errorUserProfileForbidden.localized()
        case LoginConnectionError.config:
            message = R.string.localizable.errorLoginConfig.localized()
        case LoginConnectionError.pendingUser:
            message = R.string.localizable.errorLoginPendingUser.localized()
        case LoginConnectionError.email:
            message = R.string.localizable.errorLoginEmail.localized()
        case LoginConnectionError.password:
            message = R.string.localizable.errorLoginPassword.localized()
        case LoginConnectionError.incorrectPassword:
            message = R.string.localizable.errorLoginIncorrectPassword.localized()
        case LoginConnectionError.fbToken:
            message = R.string.localizable.errorLoginFb.localized()
        case LoginConnectionError.googleToken:
            message = R.string.localizable.errorLoginGoogle.localized()
        case LoginConnectionError.appleToken:
            message = R.string.localizable.errorLoginApple.localized()
        case LoginConnectionError.wrongAuthMethod:
            message = R.string.localizable.errorLoginWrongAuthMethod.localized()
        case LoginError.tokenNil:
            message = R.string.localizable.errorUnexpectedResponse.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
}
