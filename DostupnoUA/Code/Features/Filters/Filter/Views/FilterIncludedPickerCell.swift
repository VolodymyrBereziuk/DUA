//
//  FilterIncludedPickerCell.swift
//  DostupnoUA
//
//  Created by admin on 18.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit
// ПРОДОЛЖУ ВО ВТОРОМ ЭТАПЕ, ПОКА НЕТ ВРЕМЕНИ
class FilterIncludedPickerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var filterImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetContent()
        nameLabel.font = .p2LeftRegular
        subtitleLabel.font = .p2LeftBold
        filterImageButton.setImage(R.image.forward(), for: .normal)
        nameLabel.textColor = R.color.warmGrey()
        subtitleLabel.textColor = R.color.ickyGreen()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }
    
    func resetContent() {
        nameLabel.text = ""
        subtitleLabel.text = ""
    }
    
    func set(name: String?) {
        nameLabel.text = name
    }
    
    func set(subtitle: String?) {
        subtitleLabel.text = subtitle ?? R.string.localizable.filterIncludedPickerSubtitleEmpty.localized()
    }
}
