//
//  DostupnoToken+Extensions.swift
//  DostupnoUA
//
//  Created by Anton on 23.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

extension DostupnoToken {
    
    var bearerValue: String? {
        guard let tokenValue = self.token else {
            return nil
        }
        return "Bearer" + " " + tokenValue
    }
}
