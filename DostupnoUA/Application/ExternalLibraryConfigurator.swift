//
//  ExternalLibraryConfigurator.swift
//  DostupnoUA
//
//  Created by Anton on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import FBSDKCoreKit
import Firebase
import GoogleMaps
import GoogleSignIn
import IQKeyboardManagerSwift

struct ExternalLibraryConfigurator {

    private let googleClienID = "720982746179-g36rf2pd6edcgoi323r8lttc82s6nfqq.apps.googleusercontent.com"
    private let googleMapAPIKey = "AIzaSyCihCv0P-ZiN9b0ZW28M7qa0kzOr1_0B2w"

    func setup(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = googleClienID
        setupGoogleMaps()
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // MARK: - warning need check without if else
        guard ApplicationDelegate.shared.application(app, open: url, options: options) == false else { return true }
        guard let instance = GIDSignIn.sharedInstance(), instance.handle(url) == false else { return true }
        return false
    }
    
    func setupGoogleMaps() {
        GMSServices.provideAPIKey(googleMapAPIKey)
    }
}
