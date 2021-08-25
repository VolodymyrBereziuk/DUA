//
//  SettingsCell.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet private weak var settingsImageView: UIImageView!
    @IBOutlet private weak var settingsTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsTitleLabel.font = .p2LeftBold
        settingsTitleLabel.textColor = R.color.ickyGreen()
    }
    
    func set(title: String?) {
        settingsTitleLabel.text = title
    }
    
    func set(image: UIImage?) {
        settingsImageView.image = image
    }
}
