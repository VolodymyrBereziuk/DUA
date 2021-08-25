//
//  UIView+Extensions.swift
//  OpenWeatherMap
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 Viktor Drykin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubview(_ view: UIView, edgeInsets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeInsets.bottom),
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: edgeInsets.left),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: edgeInsets.right)
        ])
    }
    
    func roundView(radius: CGFloat, color: UIColor? = .clear, borderWidth: CGFloat = 0) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = color?.cgColor
    }
    
    @discardableResult
    func applyButtonGradient(colors: [UIColor?]?) -> CAGradientLayer {
        return self.applyViewGradient(colors: colors, locations: nil)
    }

    @discardableResult
    func applyViewGradient(colors: [UIColor?]?, locations: [NSNumber]?) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let unwrappedColors = colors?.compactMap({ $0?.cgColor })
        gradient.colors = unwrappedColors
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

}
