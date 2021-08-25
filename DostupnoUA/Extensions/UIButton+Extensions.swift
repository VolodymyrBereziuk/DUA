//
//  UIButton+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setEnablingMode(to isEnabled: Bool) {
        self.isEnabled = isEnabled
        alpha = isEnabled ? 1 : 0.5
    }
}

extension UIButton {
    enum DostupnoStyle {
        case green30
    }
    
    func set(style: DostupnoStyle) {
        switch style {
        case .green30:
            //applyButtonGradient(colors: [R.color.yellowishGreenTwo(), R.color.vomitGreen()])
            backgroundColor = R.color.ickyGreen()
            titleLabel?.font = .h2LeftBold
            setTitleColor(.white, for: .normal)
            tintColor = .white
            addRoundShadow(radius: 30)
        }
    }
}
