//
//  LocalisationManager.swift
//  DostupnoUA
//
//  Created by admin on 03.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

class LocalisationManager {
    
    static let shared = LocalisationManager()
    
    private let currentLanguageKey = "currentLanguage"
    
    var availableLanguages: [String] {
        return Bundle.main.localizations
    }
    
    var defaultLanguage: String {
        let localisation = Bundle.main.preferredLocalizations.first { availableLanguages.contains($0) }
        return localisation ?? ApplicationLanguage.default.rawValue
    }
    
    var currentLanguage: ApplicationLanguage {
        get {
            let languageKey = UserDefaults.standard.string(forKey: currentLanguageKey)
            if let languageKey = languageKey, let language = ApplicationLanguage(rawValue: languageKey) {
                return language
            }
            return deviceLanguageIfSupported
        }
        
        set {
            let selectedLanguage = availableLanguages.contains(newValue.rawValue) ? newValue.rawValue : defaultLanguage
            UserDefaults.standard.set(selectedLanguage, forKey: currentLanguageKey)
            NotificationCenter.default.post(name: .LanguageDidChange,
                                            object: self,
                                            userInfo: [ApplicationLanguage.userInfoKey: newValue])
        }
    }
    
    var deviceLanguageIfSupported: ApplicationLanguage {
        let deviceLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? ""
        return ApplicationLanguage(rawValue: deviceLanguage) ?? .default
    }
    
    func useDeviceLanguageIfSupported() {
        LocalisationManager.shared.currentLanguage = deviceLanguageIfSupported
    }
}
