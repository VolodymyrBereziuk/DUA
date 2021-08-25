//
//  UIColor+CoreExtensions.swift
//  DostupnoUA
//
//  Created by admin on 9/22/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int?) {
        if let rgbInt = rgb {
            self.init(red: (rgbInt >> 16) & 0xFF, green: (rgbInt >> 8) & 0xFF, blue: rgbInt & 0xFF)
        } else {
            self.init(red: 255, green: 255, blue: 255)
        }
    }
}
