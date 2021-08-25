//
//  FilterSelectiomInfo.swift
//  DostupnoUA
//
//  Created by admin on 08.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation

struct FilterSelectionInfo {
    let mainFilterId: String
    let title: String
    let icon: String?
    let selectionType: SelectionType?
    let checkAll: Int?
    let filters: [Filter]?
}
