//
//  LineTableSectionSeparator.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class LineTableSectionSeparator: GenericHeaderFooterView {
    
    @IBOutlet weak var lineSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBackgroundView()
        lineSeparatorView.backgroundColor = R.color.whiteGrey()
    }
}
