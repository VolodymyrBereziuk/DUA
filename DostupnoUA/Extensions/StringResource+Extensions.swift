//
//  StringResource+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 03.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation
import Rswift

extension StringResource {
    
    func localized(with language: ApplicationLanguage = LocalisationManager.shared.currentLanguage) -> String {
        let languagePath = Bundle.main.path(forResource: language.rawValue, ofType: "lproj" )
        let baseLanguagePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
        let path = languagePath ?? baseLanguagePath
        
        let notLocalisedValue = "NOT LOCALISED"
        if let path = path, let bundle = Bundle(path: path) {
            return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: notLocalisedValue, comment: comment ?? "")
        } else {
            return notLocalisedValue
        }
    }
}

extension String {
    
    // In case we will get keys of localisation from BE
    func keyFromBELocalized(with language: ApplicationLanguage = LocalisationManager.shared.currentLanguage) -> String {
        let languagePath = Bundle.main.path(forResource: language.rawValue, ofType: "lproj" )
        let baseLanguagePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
        let path = languagePath ?? baseLanguagePath
        if let path = path, let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: self, comment: "")
        } else {
            return self
        }
    }
}
