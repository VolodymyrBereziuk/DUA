//
//  UIViewController+Extension.swift
//  DostupnoUA
//
//  Created by Anton on 06.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
