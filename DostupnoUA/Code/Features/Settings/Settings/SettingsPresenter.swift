//
//  SettingsPresenter.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol SettingsNavigation {
    var toLocalisation: (() -> Void)? { get set }
    var didFinish: (() -> Void)? { get set }
}

protocol SettingsViewProtocol: AnyObject {
    var presenter: SettingsPresenterProtocol? { get set }
}

protocol SettingsPresenterProtocol: AnyObject {
    var managedView: SettingsViewProtocol? { get set }
    
    func viewWillAppear()
    func numberOfRows() -> Int
    func cellData(at index: Int) -> SettingsCellViewModel?
    func didSelectItem(at index: Int)
    func backTapped()
}

class SettingsPresenter {
    var cellViewModels = [SettingsCellViewModel]()
    weak var managedView: SettingsViewProtocol?
    let navigation: SettingsNavigation
    
    init(navigation: SettingsNavigation) {
        self.navigation = navigation
    }
    
    func backTapped() {
        navigation.didFinish?()
    }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    func viewWillAppear() {
        let language = SettingsCellViewModel(icon: R.image.rename(),
                                             title: R.string.localizable.languageTitle.localized(),
                                             action: { [weak self] in
                                                self?.navigation.toLocalisation?()
            })
        cellViewModels = [language]
    }
    
    func numberOfRows() -> Int {
        return cellViewModels.count
    }
    
    func cellData(at index: Int) -> SettingsCellViewModel? {
        return cellViewModels[safe: index]
    }
    
    func didSelectItem(at index: Int) {
        let viewModel = cellViewModels[safe: index]
        viewModel?.action()
    }
}
