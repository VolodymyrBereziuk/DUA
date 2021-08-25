//
//  PersistenceManager.swift
//  DostupnoUA
//
//  Created by Anton on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    static var manager = PersistenceManager()
    
    private var userDefaults: UserDefaultsHelper
    private var keychainWrapper: KeychainWrapper

    private init() {
        userDefaults = UserDefaultsHelper()
        keychainWrapper = KeychainWrapper()
    }
    
    private var isAppAlreadyLaunchedOnce: Bool {
        get {
            return userDefaults.isAppAlreadyLaunchedOnce
        }
        set {
            userDefaults.isAppAlreadyLaunchedOnce = newValue
        }
    }
    
    var dostupnoToken: DostupnoToken? {
        get {
            return keychainWrapper.getToken()
        }
        set {
            keychainWrapper.saveToken(token: newValue)
        }
    }
    
    var isLoggedIn: Bool {
        return dostupnoToken != nil
    }
    
    func configure() {
        if isAppAlreadyLaunchedOnce == false {
            isAppAlreadyLaunchedOnce = true
            keychainWrapper.removeToken()
            //очищаем keychain
        }
    }
    
    func logout() {
        dostupnoToken = nil
        keychainWrapper.removeToken()
    }
}
