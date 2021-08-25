//
//  NSObject+Extension.swift
//  DostupnoUA
//
//  Created by Anton on 26.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

extension NSObject {
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
