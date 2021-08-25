//
//  UIView+NibLoading.swift
//  OpenWeatherMap
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 Viktor Drykin. All rights reserved.
//

import UIKit

extension UIView {
    @objc var nibName: String? {
        return type(of: self).description().components(separatedBy: ".").last
    }

    func viewFromNibWithSameName() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard let nibName = nibName else {
            return nil
        }
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }

    @discardableResult func xibSetup() -> UIView? {
        backgroundColor = .clear
        guard let view = viewFromNibWithSameName() else {
            return nil
        }
        view.frame = bounds
        addSubview(view, edgeInsets: .zero)
        return view
    }
}
