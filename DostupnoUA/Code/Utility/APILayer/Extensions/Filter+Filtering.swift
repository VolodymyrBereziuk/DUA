//
//  Filter+Filtering.swift
//  DostupnoUA
//
//  Created by admin on 22.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

extension Filter {
    
    private struct AssociatedKeys {
        static var isSelected: Bool?
        static var selectedPickerFilterId: String?
        static var selectedPickerFilterTitle: String?
        static var selectedPickerFilterKey: String? //id of included filter which we will send to BE
    }
    
    var isFilteringSelected: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isSelected) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isSelected, newValue as Bool, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var selectedPickerFilterId: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.selectedPickerFilterId) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.selectedPickerFilterId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var selectedPickerFilterTitle: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.selectedPickerFilterTitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.selectedPickerFilterTitle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var selectedPickerFilterKey: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.selectedPickerFilterKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.selectedPickerFilterKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func selectAsMultiple() {
        isFilteringSelected.toggle()
    }
    
    func selectAll() {
        children?.filter({ $0.isVisibleInFilters }).forEach({ childFilter in
            childFilter.isFilteringSelected = true
            childFilter.selectAll()
        })
    }
    
    func deselectAll() {
        children?.filter({ $0.isVisibleInFilters }).forEach({ childFilter in
            childFilter.isFilteringSelected = false
            childFilter.selectedPickerFilterId = nil
            childFilter.selectedPickerFilterTitle = nil
            childFilter.deselectAll()
        })
    }
    
    func isAllSelected() -> Bool {
        var isAllSelected = true
        for child in children ?? [] {
            if child.isFilteringSelected == false {
                isAllSelected = false
                break
            } else if child.isAllSelected() == false {
                isAllSelected = false
                break
            }
        }
        return isAllSelected// && children?.isEmpty == false
    }
    
    var isParent: Bool {
        return children?.isEmpty == false
    }
    
    // to display cross icon X on right side of filter
    func isAnyChildSelected() -> Bool {
        var isAnyChildSelected = false
        for child in children ?? [] {
            if isAnyChildSelected {
                 break
             }
            if child.isFilteringSelected || child.selectedPickerFilterId != nil {
                isAnyChildSelected = true
            } else {
                isAnyChildSelected = child.isAnyChildSelected()
            }
        }
        return isAnyChildSelected
    }
    
    var selectedIds: [String] {
        var ids = [String]()
        if isFilteringSelected {
            ids.append(id)
        }

        children?.forEach({ child in
            ids += child.selectedIds
        })
        return ids
    }
    
    var selectedIncludedFilters: [String: [String]] {
        var filters = [String: [String]]()
        if let pickerId = selectedPickerFilterId, let pickerKey = selectedPickerFilterKey {
            filters[pickerKey] = [pickerId]
        }
        children?.forEach({ child in
            filters.merge(child.selectedIncludedFilters, uniquingKeysWith: { first, _ in first })
        })
        return filters
    }
    
    var isVisibleInFilters: Bool {
        // this property is 0 or 1 in json
        let isHidden = filterHidden == 1
        return isHidden == false
    }
}
