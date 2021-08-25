//
//  UIBarButtonItem+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 05.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(backTarget: Any, action: Selector) {
        self.init(image: R.image.back(), style: .plain, target: backTarget, action: action)
    }
    
    convenience init(closeTarget: Any, action: Selector) {
        self.init(image: R.image.close(), style: .plain, target: closeTarget, action: action)
    }
}
