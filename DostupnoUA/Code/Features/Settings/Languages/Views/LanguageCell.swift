//
//  LanguageCell.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var languageTitle: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        languageTitle.textColor = R.color.warmGrey()
        languageTitle.font = UIFont.p2LeftBold
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionImageView.image = nil
        languageTitle.text = nil
    }
    
    func set(title: String?) {
        languageTitle.text = title
    }
    
    func set(isSelected: Bool?) {
        selectionImageView.image = (isSelected ?? false)
            ? R.image.singleSelectionActive()
            : R.image.singleSelectionNormal()
    }
    
}
