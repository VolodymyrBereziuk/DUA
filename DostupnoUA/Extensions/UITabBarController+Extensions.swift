//
//  UITabBarController+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 03.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func setTabBar(isHidden: Bool, animated: Bool = false, completion: (() -> Void)? = nil ) {
        guard tabBar.isHidden != isHidden else {
            return
        }
        
        if tabBar.isHidden == isHidden {
            completion?()
        }
        
        if !isHidden {
            tabBar.isHidden = false
        }
        
        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.25 : 0.0)
        
        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        UIView.animate(withDuration: duration,
                       animations: {
                        self.tabBar.frame = frame
        },
                       completion: { _ in
                        self.tabBar.isHidden = isHidden
                        completion?()
        })
    }
}
