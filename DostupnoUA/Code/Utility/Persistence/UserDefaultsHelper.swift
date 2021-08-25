//
//  UserDefaultsHelper.swift
//  DostupnoUA
//
//  Created by Anton on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

let kToken = "token"
let kIsAppAlreadyLaunchedOnce = "isAppAlreadyLaunchedOnce"

struct UserDefaultsHelper {
    
    private let userDefaults = UserDefaults.standard
    
    var isAppAlreadyLaunchedOnce: Bool {
        get {
            return userDefaults.bool(forKey: kIsAppAlreadyLaunchedOnce)
        }
        set {
            userDefaults.set(newValue, forKey: kIsAppAlreadyLaunchedOnce)
        }
    }
    
}
