//
//  CGRect+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

public extension CGRect {
    
    static var layoutDefaultValue: CGRect {
        return CGRect(x: 0, y: 0, width: 1000, height: 1000)
    }
    
    init(withHeight height: CGFloat) {
        self.init(x: 0, y: 0, width: 0, height: height)
    }
}
