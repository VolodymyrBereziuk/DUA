//
//  UIEdgeInsets+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 01.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    init(left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
//    
//    init(left: CGFloat) {
//        self.init(top: 0, left: left, bottom: 0, right: 0)
//    }
//    
//    init(right: CGFloat) {
//        self.init(top: 0, left: 0, bottom: 0, right: right)
//    }
//    
//    init(top: CGFloat) {
//        self.init(top: top, left: 0, bottom: 0, right: 0)
//    }
//    
//    init(bottom: CGFloat) {
//        self.init(top: 0, left: 0, bottom: bottom, right: 0)
//    }
}
