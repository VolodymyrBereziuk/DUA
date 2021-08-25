//
//  LanguagesPresenter.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol LanguagesViewProtocol: AnyObject {
    var presenter: LanguagesPresenterProtocol? { get set }
}

protocol LanguagesPresenterProtocol: AnyObject {
    
    func prepareContent()
    func numberOfRows() -> Int
    func cellData(at index: Int) -> LanguageViewModel?
    func didSelectItem(at index: Int)
}

class LanguagesPresenter {
    
    var cellViewModels = [LanguageViewModel]()
    
    init() {
        prepareContent()
    }
}

extension LanguagesPresenter: LanguagesPresenterProtocol {
    
    func numberOfRows() -> Int {
        return cellViewModels.count
    }
    
    func cellData(at index: Int) -> LanguageViewModel? {
        return cellViewModels[safe: index]
    }
    
    func didSelectItem(at index: Int) {
        guard let viewModel = cellViewModels[safe: index] else { return }
        cellViewModels.forEach { $0.isSelected = false }
        viewModel.isSelected = true
        LocalisationManager.shared.currentLanguage = viewModel.language
    }
    
    func prepareContent() {
        cellViewModels.removeAll()
        for bundleLanguage in LocalisationManager.shared.availableLanguages {
            
            let appLanguage = ApplicationLanguage(rawValue: bundleLanguage)
            let isSelectedLanguage = appLanguage == LocalisationManager.shared.currentLanguage
            let viewModel: LanguageViewModel?
            
            switch appLanguage {
            case .english:
                viewModel = LanguageViewModel(title: R.string.localizable.languageEnglishTitle.localized(),
                                              language: .english,
                                              isSelected: isSelectedLanguage)
            case .ukrainian:
                viewModel = LanguageViewModel(title: R.string.localizable.languageUkrainianTitle.localized(),
                                              language: .ukrainian,
                                              isSelected: isSelectedLanguage)
            case .none:
                viewModel = nil
            }
            
            if let viewModel = viewModel {
                cellViewModels.append(viewModel)
            }
        }
        
    }
}
