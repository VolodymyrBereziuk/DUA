//
//  Filter+Utils.swift
//  DostupnoUA
//
//  Created by admin on 17.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

extension Filter {
    
    // to find titles of filters by filters identifiers
    func getTitles(ids: [String]?) -> [String] {
        var titles = [String?]()
        ids?.forEach { id in
            titles += getTitles(of: id)
        }
        return titles.compactMap({ $0 })
    }
    
    private func getTitles(of id: String) -> [String?] {
        var titles = [String?]()
        if id == self.id {
            titles.append(self.title)
        }
        children?.forEach({ childFilter in
            titles += childFilter.getTitles(of: id)
        })
        
        return titles
    }
    
    var displayedLocation: (latitude: Double, longitude: Double, zoom: Float)? {
        guard
            let latitude = Double(location?.latitude ?? ""),
            let longitude = Double(location?.longitude ?? ""),
            let zoom = Float(location?.zoom ?? "")
        else {
            return nil
        }
        return (latitude: latitude, longitude: longitude, zoom: zoom)
    }
}
