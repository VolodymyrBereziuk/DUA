//
//  LoginManager.swift
//

//import FBSDKCoreKit
//import FBSDKLoginKit

import FBSDKLoginKit
import Foundation
import GoogleSignIn
import UIKit
import AuthenticationServices

enum SocialNetworkType: String, Codable {
    case apple = "apple"
    case facebook = "fb"
    case google = "google"
    case email
}

protocol SocialLoginManagerDelegate: AnyObject {
    func returnNetworkData(token: String, typeSocial: SocialNetworkType)
}

class SocialLoginManager: NSObject {
    
    static let shared = SocialLoginManager()
    weak var delegate: SocialLoginManagerDelegate?
    
    private var presentVC = UIViewController()
    
    func authorize(with socialNetwork: SocialNetworkType, viewController: UIViewController) {
        presentVC = viewController
        switch socialNetwork {
        case .facebook:
            authorizeWithFacebook()
        case .google:
            authorizeWithGoogle()
        case .apple:
            if #available(iOS 13.0, *) {
                authorizeWithApple()
            }
        case .email:
            break
        }
    }
    
    private func authorizeWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [], from: presentVC) { [weak self] loginResult, _ in
            if let token = loginResult?.token?.tokenString {
                self?.delegate?.returnNetworkData(token: token, typeSocial: .facebook)
            }
        }
    }
    
    private func authorizeWithGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = presentVC
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    @available(iOS 13.0, *)
    private func authorizeWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}

extension SocialLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
            
        guard let tokenData = appleIDCredential.identityToken, let token = String(data: tokenData, encoding: .utf8), !token.isEmpty else { return }
        self.delegate?.returnNetworkData(token: token, typeSocial: .apple)
        case _ as ASPasswordCredential:
            break
        default:
            break
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentVC.view.window ?? UIWindow()
    }
}

extension SocialLoginManager: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil {
            guard let token = user.authentication.idToken, !token.isEmpty && error == nil else { return }
            self.delegate?.returnNetworkData(token: token, typeSocial: .google)
        }
    }
    
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        if (error == nil && signIn.currentUser != nil) {
//            //            let gAccessToken = signIn.currentUser.authentication.accessToken
//            guard let token = signIn.currentUser.authentication.idToken, token.count>0 else { return }
//            self.delegate?.returnNetworkData(token: token, typeSocial: .google)
//        }
//    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        presentVC.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presentVC.present(viewController, animated: true, completion: nil)
    }
    
}
