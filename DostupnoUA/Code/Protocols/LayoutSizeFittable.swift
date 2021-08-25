//
//  LayoutSizeFittable.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit
// this protocol allow us to force view to perform autolayout (for example can be autolayouted footerView in UITableView)
protocol LayoutSizeFittable {
    func updateHeightConstraint()
}

extension UIView: LayoutSizeFittable {
    func updateHeightConstraint() {
        let newHeight = systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0),
                                                withHorizontalFittingPriority: .required,
                                                verticalFittingPriority: .fittingSizeLevel).height
        if newHeight != bounds.height {
            bounds.size.height = newHeight
        }
    }
}
