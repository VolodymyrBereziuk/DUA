//
//  VersionComparator.swift
//  DostupnoUA
//
//  Created by admin on 25.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

struct VersionComparator {
    
    private static let versionSeparator = "."
    
    static func isUpdateNeeded(minVersion: String?) -> Bool {
        guard let minVersion = minVersion else {
            return false
        }
        guard let dictionary = Bundle.main.infoDictionary,
            let currentVersion = dictionary["CFBundleShortVersionString"] as? String else {
                return false
        }
        
        return isCurrentVersionLower(minVersion: minVersion, currentVersion: currentVersion)
    }
    
    static func isCurrentVersionLower(minVersion: String, currentVersion: String) -> Bool {
        let minParts = minVersion.split(separator: ".")
        let currentParts = currentVersion.split(separator: ".")
        
        for (index, item) in minParts.enumerated() {
            let currentPart = Int(currentParts[safe: index] ?? "0") ?? 0
            let minPart = Int(item) ?? 0
            if currentPart > minPart {
                return false
            } else if currentPart == minPart {
                continue
            } else {
                return true
            }
        }
        
        return false
    }
    
}
