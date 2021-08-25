//
//  GenericHeaderFooterView.swift
//  DostupnoUA
//
//  Created by admin on 20.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class GenericHeaderFooterView: UITableViewHeaderFooterView {
    
    func addBackgroundView() {
        backgroundView = UIView(frame: bounds)
    }
    
    func set(backgroundColor: UIColor?) {
        backgroundView?.backgroundColor = backgroundColor
    }
    
}
