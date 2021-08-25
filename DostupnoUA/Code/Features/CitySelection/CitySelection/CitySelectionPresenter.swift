//
//  CitySelectionPresenter.swift
//  DostupnoUA
//
//  Created by admin on 23.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol CitySelectionNavigation {
    var didFinish: ((String, String?) -> Void)? { get set }
    var didClearSelection: ((String) -> Void)? { get set }
    var didCancel: (() -> Void)? { get set }
}

protocol CitySelectionViewProtocol: AnyObject {
    func reloadCityTableView()
    func set(currentCity: String?)
    func setClearButton(isHidden: Bool)
}

protocol CitySelectionPresenterProtocol: AnyObject {
    
    var managedView: CitySelectionViewProtocol? { get set }
    var numberOfRows: Int? { get }
    
    func viewDidLoad()
    func cellModel(at index: Int) -> CityModel?
    func backTapped()
    func didSelectCell(at index: Int)
    func set(citySearchText: String?)
    func didClearSelection()
}

class CitySelectionPresenter: CitySelectionPresenterProtocol {
    
    weak var managedView: CitySelectionViewProtocol?
    var navigation: CitySelectionNavigation
    
    let cityId: String?
    var currentCityModel: CityModel?
    
    var allCityModels = [CityModel]()
    var filteredCityModels = [CityModel]()
    
    init(navigation: CitySelectionNavigation, cityId: String?) {
        self.navigation = navigation
        self.cityId = cityId
    }
    
    func viewDidLoad() {
        StorageManager.shared.getFilters(language: LocalisationManager.shared.currentLanguage.rawValue, onSuccess: { [weak self] filtersList in
            self?.allCityModels = self?.makeAllCityModels(from: filtersList) ?? []
            self?.filteredCityModels = self?.allCityModels ?? []
            self?.currentCityModel = self?.allCityModels.first(where: { $0.id == self?.cityId })
            self?.setCurrentCityName()
            self?.managedView?.reloadCityTableView()
            if self?.cityId != nil {
                self?.managedView?.setClearButton(isHidden: false)
            }
        })
    }
    
    func setCurrentCityName() {
        var currentCityName = R.string.localizable.editProfileInfoCityPlaceholder.localized()
        if let cityName = currentCityModel?.name, cityName.isEmptyOrWhitespace == false {
            currentCityName = cityName + " " + currentCityName
        }
        managedView?.set(currentCity: currentCityName)
    }
    
    func backTapped() {
        navigation.didCancel?()
    }
    
    func didClearSelection() {
        if let cityId = cityId {
            navigation.didClearSelection?(cityId)
        }
    }
    
    func makeAllCityModels(from filterList: FiltersList?) -> [CityModel] {
        var models = [CityModel]()
        let cities = filterList?.cities?.filters
        cities?.forEach({ filter in
            let model = CityModel(name: filter.title, id: filter.id)
            models.append(model)
        })
        return models
    }
    
    func filterCityModels(allModels: [CityModel], searchText: String? = nil) -> [CityModel] {
        let cities = allModels.filter {
            if searchText?.isEmptyOrWhitespace ?? true {
                return true
            }
            return $0.name?.uppercased().contains(searchText?.uppercased() ?? "") ?? true
        }
        return cities
    }
    
    func set(citySearchText: String?) {
        filteredCityModels = filterCityModels(allModels: allCityModels, searchText: citySearchText)
        managedView?.reloadCityTableView()
    }
    
    var numberOfRows: Int? {
        return filteredCityModels.count
    }
    
    func cellModel(at index: Int) -> CityModel? {
        return filteredCityModels[safe: index]
    }
    
    func didSelectCell(at index: Int) {
        guard let cityModel = filteredCityModels[safe: index] else {
            return
        }
        navigation.didFinish?(cityModel.id, cityModel.name)
    }
}
