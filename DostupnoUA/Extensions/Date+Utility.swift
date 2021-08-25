//
//  Date+Utility.swift
//  OpenWeatherMap
//
//  Created by Viktor Drykin on 14.03.2018.
//  Copyright © 2018 Viktor Drykin. All rights reserved.
//

import Foundation

extension Date {
    var text: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
