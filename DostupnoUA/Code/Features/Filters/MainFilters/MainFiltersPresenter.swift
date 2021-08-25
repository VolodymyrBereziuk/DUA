//
//  MainFiltersPresenter.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

protocol MainFiltersNavigation {
    var didFinish: (() -> Void)? { get set }
    var toFilter: ((FilterSelectionInfo) -> Void)? { get set }
    var toGetLocations: (() -> Void)? { get set }
    var toCitySelection: ((String?) -> Void)? { get set }
}

protocol MainFiltersViewProtocol: AnyObject {
    func reloadFiltersTableView()
    func set(currentCity: String?)
    func setClearAllButton(isHidden: Bool)
}

protocol MainFiltersPresenterProtocol: AnyObject {
    var managedView: MainFiltersViewProtocol? { get set }
    
    var numberOfRows: Int? { get }
    
    func cellModel(at indexPath: IndexPath) -> MainFiltersModel?
    func viewWillAppear()
    func backTapped()
    func didSearchResults()
    func didSelectCell(at indexPath: IndexPath, isSelected: Bool)
    func didClearAllFilters()
    func showCitySelection()
    
    func updateCurrentCity(name: String?)
    func clearCurrentCity()
    func setCurrentCityId(_ currentCityId: String?)
}

class MainFiltersPresenter: MainFiltersPresenterProtocol {
    
    weak var managedView: MainFiltersViewProtocol?
    var navigation: MainFiltersNavigation
    
    var filterList: FiltersList?
    var cellModels = [MainFiltersModel]()
    
    init(navigation: MainFiltersNavigation) {
        self.navigation = navigation
    }
    
    func viewWillAppear() {
        let cityId = StorageManager.shared.currentCityId
        StorageManager.shared.getFilters(language: LocalisationManager.shared.currentLanguage.rawValue, onSuccess: { [weak self] filtersList in
            self?.filterList = filtersList
            let filter = self?.filterList?.cities?.filters?.first(where: { $0.id == cityId })
            self?.updateCurrentCity(name: filter?.title)
            self?.updateDisplayedData()
        })
    }
    
    func prepareCellModels(filterList: FiltersList?) {
        cellModels.removeAll()
        filterList?.main?.forEach({ [weak self] mainFilter in
            let model = MainFiltersModel(imageName: mainFilter.icon, name: mainFilter.title, isSelected: mainFilter.isAnyFilterSelected())
            self?.cellModels.append(model)
        })
    }
    
    func updateCurrentCity(name: String?) {
        managedView?.set(currentCity: name ?? R.string.localizable.filterCitySearchTextFieldTitle.localized())
    }
    
    func setCurrentCityId(_ currentCityId: String?) {
        StorageManager.shared.currentCityId = currentCityId
    }
    
    func clearCurrentCity() {
        StorageManager.shared.currentCityId = nil
        managedView?.set(currentCity: R.string.localizable.filterCitySearchTextFieldTitle.localized())
    }
    
    var numberOfRows: Int? {
        return filterList?.main?.count ?? 0
    }
    
    func cellModel(at indexPath: IndexPath) -> MainFiltersModel? {
        return cellModels[safe: indexPath.row]
    }
    
    func backTapped() {
        navigation.didFinish?()
    }
    
    func didSearchResults() {
        navigation.toGetLocations?()
    }
    
    func showCitySelection() {
        navigation.toCitySelection?(StorageManager.shared.currentCityId)
    }
    
    func didSelectCell(at indexPath: IndexPath, isSelected: Bool) {        
        guard isSelected == false else {
            deselectFilters(at: indexPath)
            return
        }
        guard let mainFilter = filterList?.main?[safe: indexPath.row] else {
            return
        }
        let visibleFilters = mainFilter.filters?.filter { $0.isVisibleInFilters }
        let filterSelectionInfo = FilterSelectionInfo(mainFilterId: mainFilter.id,
                                                      title: mainFilter.title,
                                                      icon: mainFilter.icon,
                                                      selectionType: mainFilter.selectionFilterType,
                                                      checkAll: mainFilter.checkAll,
                                                      filters: visibleFilters)
        navigation.toFilter?(filterSelectionInfo)
    }
    
    private func deselectFilters(at indexPath: IndexPath) {
        filterList?.main?[safe: indexPath.row]?.deselectAllFilters()
        updateDisplayedData()
    }
    
    func didClearAllFilters() {
        filterList?.main?.forEach({ mainFilter in
            mainFilter.deselectAllFilters()
        })
        updateDisplayedData()
    }
    
    func updateDisplayedData() {
        prepareCellModels(filterList: filterList)
        managedView?.reloadFiltersTableView()
        managedView?.setClearAllButton(isHidden: isHiddenClearFiltersButton)
    }
    
    var isHiddenClearFiltersButton: Bool {
        var isHidden = true
        for mainFilter in filterList?.main ?? [] {
            if mainFilter.isAnyFilterSelected() {
                isHidden = false
                break
            }
        }
        return isHidden
    }
}
