//
//  UIView+Frame.swift
//  DostupnoUA
//
//  Created by Anton on 18.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: - Getters
    
    func frameX() -> CGFloat {
        return frame.origin.x
    }

    func frameY() -> CGFloat {
        return frame.origin.y
    }

    func frameWidth() -> CGFloat {
        return frame.size.width
    }

    func frameHeight() -> CGFloat {
        return frame.size.height
    }

    // MARK: - Setters
    
    func setFrameX(x: CGFloat) {
        frame = CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
    }

    func setFrameY(y: CGFloat) {
        frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height)
    }

    func setFrameWidth(width: CGFloat) {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
    }

    func setFrameHeight(height: CGFloat) {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
    }
    
}
