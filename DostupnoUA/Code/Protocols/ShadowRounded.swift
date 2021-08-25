//
//  ShadowRounded.swift
//  DostupnoUA
//
//  Created by admin on 01.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol ShadowRounded {
    func addRoundShadow(color: UIColor?, radius: CGFloat)
}

extension UIView: ShadowRounded {
    
    func addRoundShadow(color: UIColor? = R.color.blueGray(), radius: CGFloat = 9) {
        layer.cornerRadius = radius
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
    }
}
