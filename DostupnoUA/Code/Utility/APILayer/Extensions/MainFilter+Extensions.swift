//
//  MainFilter+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 23.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

extension MainFilter {
    
    func isAnyFilterSelected() -> Bool {
        var isAnyFilterSelected = false
        for filter in filters ?? [] {
            if isAnyFilterSelected {
                 break
             }
            if filter.isFilteringSelected || filter.selectedPickerFilterId != nil {
                isAnyFilterSelected = true
            } else {
                isAnyFilterSelected = filter.isAnyChildSelected()
            }
        }
        return isAnyFilterSelected
    }
    
    func deselectAllFilters() {
        filters?.forEach({ filter in
            filter.isFilteringSelected = false
            filter.selectedPickerFilterId = nil
            filter.selectedPickerFilterTitle = nil
            filter.deselectAll()
        })
    }
    
    var requestLocationsInfo: [String: [String]]? {
        var ids = [String]()
        filters?.forEach({ filter in
            ids += filter.selectedIds
        })
        
        var info = [id: ids]
        filters?.forEach({ filter in
            info.merge(filter.selectedIncludedFilters, uniquingKeysWith: { first, _  in first })
        })

        let result = info.filter({ $1.isEmpty == false })
        return result.isEmpty ? nil : info
    }
}
