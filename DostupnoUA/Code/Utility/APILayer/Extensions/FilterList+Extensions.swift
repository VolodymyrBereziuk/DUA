//
//  FilterList+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

enum Acc: String, Codable {
    case bad
    case good
    case mid
}

enum SelectionType: String, Codable {
    case checkbox = "checkbox"
    case includedPicker = "included_picker"
    case radio = "radio"
}

protocol Filterable {
    var filterType: String? { get } //EditTypeEnum
    var editType: String? { get } //EditTypeEnum
    var acc: String? { get } //Acc
}

extension Filterable {
    
    var accType: Acc? {
        return Acc(rawValue: acc ?? "")
    }
    
    var selectionFilterType: SelectionType? {
        return SelectionType(rawValue: filterType ?? "")
    }
    
    var editFilterType: SelectionType? {
        return SelectionType(rawValue: editType ?? "")
    }
}
