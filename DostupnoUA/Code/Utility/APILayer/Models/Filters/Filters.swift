// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let filtersObject = try? newJSONDecoder().decode(FiltersObject.self, from: jsonData)

import Foundation

// MARK: - FiltersObject
class FiltersList: Codable {
    let main: [MainFilter]?
    let included: [MainFilter]?
    let cities: MainFilter?

    init(main: [MainFilter]?, included: [MainFilter]?, cities: MainFilter?) {
        self.main = main
        self.included = included
        self.cities = cities
    }
}

// MARK: - Included
class MainFilter: Codable, Filterable {
    let id: String
    let title: String
    let filters: [Filter]?
    var filterType: String? //EditTypeEnum
    var editType: String? //EditTypeEnum
    let addCustom: Int?
    var acc: String? //Acc
    let editRequired: Int?
    let fields: [String]?
    let icon: String?
    let defaultFilter: String?
    let checkAll: Int?

    enum CodingKeys: String, CodingKey {
        case title, id, filters
        case filterType = "filter_type"
        case editType = "edit_type"
        case addCustom = "add_custom"
        case acc, fields
        case editRequired = "edit_required"
        case icon
        case defaultFilter
        case checkAll = "check_all"
    }

    init(id: String, title: String, filters: [Filter]?, filterType: String?, editType: String?, addCustom: Int?, acc: String?, editRequired: Int?, fields: [String]?, icon: String?, defaultFilter: String?, checkAll: Int?) {
        self.id = id
        self.title = title
        self.filters = filters
        self.filterType = filterType
        self.editType = editType
        self.addCustom = addCustom
        self.acc = acc
        self.fields = fields
        self.editRequired = editRequired
        self.icon = icon
        self.defaultFilter = defaultFilter
        self.checkAll = checkAll
    }
}

class FilterLocation: Codable {
    let latitude: String?
    let longitude: String?
    let zoom: String?
}

// MARK: - Filter
class Filter: Codable, Filterable {
    let id: String
    let title: String
    let children: [Filter]?
    var filterType: String? //EditTypeEnum
    var editType: String? //EditTypeEnum
    let addCustom: Int?
    var acc: String? //Acc
    var filterHidden: Int?
    let location: FilterLocation?
    let hideFilters: [String]?

    enum CodingKeys: String, CodingKey {
        case title, id, children
        case filterType = "filter_type"
        case editType = "edit_type"
        case addCustom = "add_custom"
        case acc
        case filterHidden = "filter_hidden"
        case location
        case hideFilters = "hide_filters"

    }

    init(title: String, id: String, children: [Filter], filterType: String?, editType: String?, addCustom: Int?, acc: String?, filterHidden: Int?, location: FilterLocation?, hideFilters: [String]?) {
        self.title = title
        self.id = id
        self.children = children
        self.filterType = filterType
        self.editType = editType
        self.addCustom = addCustom
        self.acc = acc
        self.filterHidden = filterHidden
        self.location = location
        self.hideFilters = hideFilters

    }
}

extension Filter {
    enum FilterID: String {
        case type = "type_filter"
        case dostupnoRecommends = "available_recommended_filter"
        case enter = "enter_filter"
        case bathroom = "bathroom_filter"
        case indoor = "indoor_filter"
        case staff = "stuff_filter"
        case parking = "parking_filter"
        case child = "child_filter"
        case braille = "braille_filter"
        //case bikeParking = "bike_parking_exist"
        case pets = "pets_allowed"
    }
}

extension Filter {
    enum IncludeFilterID: String {
        case enterWidth = "enter_width"
        case enterDoorstepHeight = "enter_doorstep_height"
        case enterHandrailsHeight = "enter_handrails_height"
        case bathroomWidth = "bathroom_width"
    }
}
