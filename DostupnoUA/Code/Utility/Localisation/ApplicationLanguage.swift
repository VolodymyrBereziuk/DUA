//
//  ApplicationLanguage.swift
//  DostupnoUA
//
//  Created by admin on 03.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

public enum ApplicationLanguage: String {
    case english = "en"
    case ukrainian = "uk"
    
    public static let `default` = ApplicationLanguage.ukrainian
    
    public static let userInfoKey = "newValue"
    
    public func locale() -> Locale {
        return Locale(identifier: rawValue)
    }
}
