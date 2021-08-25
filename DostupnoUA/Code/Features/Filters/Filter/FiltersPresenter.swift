//
//  FiltersPresenter.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol FiltersNavigation {
    var didFinish: (() -> Void)? { get set }
    var toFilter: ((FilterSelectionInfo) -> Void)? { get set }
    var toGetLocations: (() -> Void)? { get set }
}

protocol FiltersViewProtocol: AnyObject {
    func reloadFiltersTableView()
    func set(title: String?)
    func set(titleImageName: String?)
    func showPicker(titles: [String], selectedItem: Int, onDidSelect: @escaping ((Int?) -> Void))
}

protocol FiltersPresenterProtocol: AnyObject {
    var managedView: FiltersViewProtocol? { get set }
    
    var numberOfRows: Int? { get }
    
    func viewDidLoad()
    func updateContent()
    
    func cellModel(at indexPath: IndexPath) -> FilterCellModel?
    func filter(at indexPath: IndexPath) -> Filter?
    func didTapSelectAll(at indexPath: IndexPath?)
    func didSelectFilter(at indexPath: IndexPath?)
    func didTapFilterCell(at indexPath: IndexPath?)
    func didSearchResults()
}

class FiltersPresenter: FiltersPresenterProtocol {
    
    weak var managedView: FiltersViewProtocol?
    var navigation: FiltersNavigation
    
    var filterSelectionInfo: FilterSelectionInfo
    var cellModels = [FilterCellModel]()
    var includedList: [MainFilter]?
    
    init(navigation: FiltersNavigation, filterSelectionInfo: FilterSelectionInfo) {
        self.navigation = navigation
        self.filterSelectionInfo = filterSelectionInfo
    }
    
    func viewDidLoad() {
        managedView?.set(title: filterSelectionInfo.title)
        managedView?.set(titleImageName: filterSelectionInfo.icon)
        StorageManager.shared.getFilters(onSuccess: { [weak self] list in
            self?.includedList = list.included
        })
    }
    
    func updateContent() {
        prepareCellModels(info: filterSelectionInfo)
        managedView?.reloadFiltersTableView()
    }
    
    func prepareCellModels(info: FilterSelectionInfo) {
        cellModels.removeAll()
        filterSelectionInfo.filters?.forEach { [weak self] filter in
            if let self = self {
                let model = self.makeModel(of: filter, selectionType: self.filterSelectionInfo.selectionType)
                self.cellModels.append(model)
            }
        }
    }
    
    func filter(at indexPath: IndexPath) -> Filter? {
        return filterSelectionInfo.filters?[safe: indexPath.row]
    }
    
    var numberOfRows: Int? {
        return cellModels.count
    }
    
    func cellModel(at indexPath: IndexPath) -> FilterCellModel? {
        return cellModels[safe: indexPath.row]
    }
    
    func didTapSelectAll(at indexPath: IndexPath?) {
        guard let indexPath = indexPath, let filter = filterSelectionInfo.filters?[safe: indexPath.row] else {
            return
        }
        if filter.isAllSelected() {
            filter.deselectAll()
        } else {
            filter.selectAll()
        }
        updateContent()
    }
    
    func didTapFilterCell(at indexPath: IndexPath?) {
        guard let indexPath = indexPath, let filter = filterSelectionInfo.filters?[safe: indexPath.row] else {
            return
        }
        
        if filter.children?.isEmpty == false {
            runSubfilterScreen(for: filter)
        } else if filter.selectionFilterType == .includedPicker {
            showActionPickerIfNeeded(for: filter)
        }
    }
        
    func didSelectFilter(at indexPath: IndexPath?) {
        guard let indexPath = indexPath, let filter = filterSelectionInfo.filters?[safe: indexPath.row] else {
            return
        }
        if filter.isParent && filter.isAnyChildSelected() {
            filter.deselectAll()
            updateContent()
            return
        } else if filter.isParent && filter.isAnyChildSelected() == false {
            didTapFilterCell(at: indexPath)
        }
         
        switch filterSelectionInfo.selectionType {
        case .checkbox?:
            filter.selectAsMultiple()
        case .radio?:
            filterSelectionInfo.filters?.forEach { $0.isFilteringSelected = false }
            filter.isFilteringSelected = true
        case .includedPicker?:
            didTapFilterCell(at: indexPath)
        case .none:
            break
        }
        updateContent()
    }

    func didSearchResults() {
        navigation.toGetLocations?()
    }
    
    func showActionPickerIfNeeded(for filter: Filter) {
        guard filter.selectionFilterType == .includedPicker else {
            return
        }
        let includedFilter = includedList?.first(where: { $0.id == filter.id })
        let itemsList = includedFilter?.filters
        let selectedItemIndex = itemsList?.firstIndex(where: { $0.id == filter.selectedPickerFilterId })
        let titles = itemsList?.map({ $0.title }) ?? []
        let onDidSelectAction: (Int?) -> Void = { [weak self] selectedIndex in
            if let selectedIndex = selectedIndex {
                filter.selectedPickerFilterId = itemsList?[safe: selectedIndex]?.id
                filter.selectedPickerFilterTitle = itemsList?[safe: selectedIndex]?.title
                filter.selectedPickerFilterKey = includedFilter?.id
            } else {
                filter.selectedPickerFilterId = nil
                filter.selectedPickerFilterTitle = nil
                filter.selectedPickerFilterKey = nil
            }
            self?.managedView?.reloadFiltersTableView()
            
        }
        managedView?.showPicker(titles: titles, selectedItem: selectedItemIndex ?? 0, onDidSelect: onDidSelectAction)
    }
    
    func runSubfilterScreen(for filter: Filter) {
        let visibleFilters = filter.children?.filter { $0.isVisibleInFilters }
        let filterInfo = FilterSelectionInfo(mainFilterId: filterSelectionInfo.mainFilterId,
                                             title: filter.title,
                                             icon: filterSelectionInfo.icon,
                                             selectionType: filter.selectionFilterType,
                                             checkAll: 0,
                                             filters: visibleFilters)
        navigation.toFilter?(filterInfo)
    }
    
    func makeModel(of filter: Filter, selectionType: SelectionType?) -> FilterCellModel {
        let name = filter.title
        var nameColor = filter.isParent ? R.color.ickyGreen() : R.color.warmGrey()
        let leftButtonImage: UIImage?
        if filterSelectionInfo.checkAll?.isTrue == true && filter.isParent {
            leftButtonImage = filter.isAllSelected() ? R.image.multiSelectionActive() : R.image.multiSelectionNormal()
        } else {
            leftButtonImage = nil
        }
        
        var rightButtonImage: UIImage?
        
        switch selectionType {
        case .checkbox?:
            rightButtonImage = filter.isFilteringSelected ? R.image.multiSelectionActive() : R.image.multiSelectionNormal()
        case .radio?:
            rightButtonImage = filter.isFilteringSelected ? R.image.singleSelectionActive() :  R.image.singleSelectionNormal()
        case .includedPicker?:
            rightButtonImage = R.image.forward()
            nameColor = R.color.ickyGreen()
        case .none:
            break
        }
        
        if filter.selectionFilterType == .includedPicker {
            rightButtonImage = R.image.forward()
            nameColor = R.color.ickyGreen()
        }
        
        if filter.isParent {
            rightButtonImage = filter.isAnyChildSelected() ? R.image.closeCircle() : R.image.forward()
        }
        
        let model = FilterCellModel(name: name, nameColor: nameColor, leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, isParentFilter: filter.isParent)
        return model
    }
}
