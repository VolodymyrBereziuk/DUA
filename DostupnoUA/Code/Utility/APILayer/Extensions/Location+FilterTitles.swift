//
//  Location+FilterTitles.swift
//  DostupnoUA
//
//  Created by admin on 01.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

extension Location {
    
    func getTitle(for filterID: Filter.FilterID, inside mainFilters: [MainFilter]?) -> String? {
        
        let filterIdsMapping: [Filter.FilterID: [String]?] = [.type: typeFilter,
                                                              .enter: enterFilter,
                                                              .bathroom: bathroomFilter,
                                                              .indoor: indoorFilter,
                                                              .staff: stuffFilter,
                                                              .parking: parkingFilter,
                                                              .child: childFilter,
                                                              .braille: brailleFilter,
                                                              .dostupnoRecommends: dostupnoRecommendsFilter,
//                                                              .bikeParking: bikeParkingFilter,
                                                              .pets: petsFilter]
        // here was redundant_nil_coalescing because of double optionals
        let ids: [String]? = filterIdsMapping[filterID]!
        let typeFilter = mainFilters?.first(where: { $0.id == filterID.rawValue })
        let allTitles = getTitles(of: typeFilter, ids: ids)
        let combinedTitle = allTitles.joined(separator: " / ")
        return combinedTitle
    }
    
    func getTitle(for inlcudeFilterID: Filter.IncludeFilterID, inside includeFilters: [MainFilter]?) -> String? {
        
        let filterIdsMapping: [Filter.IncludeFilterID: [String]?] = [
            .enterWidth: [enterWidth ?? ""],
            .enterDoorstepHeight: [enterDoorstepHeight ?? ""],
            .enterHandrailsHeight: [enterHandrailsHeight ?? ""],
            .bathroomWidth: [bathroomWidth ?? ""]
        ]
        // here was redundant_nil_coalescing because of double optionals
        let ids: [String]? = filterIdsMapping[inlcudeFilterID]!
        let typeFilter = includeFilters?.first(where: { $0.id == inlcudeFilterID.rawValue })
        let allTitles = getTitles(of: typeFilter, ids: ids)
        let combinedTitle = allTitles.joined(separator: " / ")
        return combinedTitle
    }
    
    private func getTitles(of typeFilter: MainFilter?, ids: [String]?) -> [String] {
        var titles = [String]()
        typeFilter?.filters?.forEach({ filter in
            titles += filter.getTitles(ids: ids)
        })
        return titles
    }
    
    func isHiddenFilter(for type: Filter.FilterID) -> Bool {
        let allHideFilters = getHiddenFilterTypes()
        for filter in allHideFilters where filter == type.rawValue {
            return true
        }
        return false
    }
    
    private func getHiddenFilterTypes() -> [String] {
        let allHideFilters = StorageManager.shared.allHiddenFilters()
        var allHideFiltersArray = [String]()
        self.typeFilter?.forEach({ typeFilterId in
            let values = allHideFilters[typeFilterId]
            if let values = values {
                allHideFiltersArray.append(contentsOf: values)
            }
        })
        return allHideFiltersArray
    }
}
