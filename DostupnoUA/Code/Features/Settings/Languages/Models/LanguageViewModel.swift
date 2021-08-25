//
//  LanguagesViewModel.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class LanguageViewModel {
    let title: String?
    let language: ApplicationLanguage
    var isSelected: Bool
    
    init(title: String?, language: ApplicationLanguage, isSelected: Bool) {
        self.title = title
        self.language = language
        self.isSelected = isSelected
    }
}
