//
//  UICollectionView+Extensions.swift
//  DostupnoUA
//
//  Created by Anton on 13.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<View: ReusableView>(_ type: View.Type) {
        if type is UICollectionViewCell.Type {
            register(type.nib, forCellWithReuseIdentifier: type.reuseKey)
        }
    }
    
    func dequeueCell<Cell: ReusableView>(_ type: Cell.Type, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: type.reuseKey, for: indexPath)
    }
}
