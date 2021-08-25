//
//  ProfileCell.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class EditProfileDisclosureCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var onActionTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        label.textColor = R.color.warmGrey()
        containerView.roundView(radius: 9, color: R.color.ickyGreen(), borderWidth: 1)
    }
    
    func set(model: EditProfileCellViewModel?) {
        label.text = model?.text ?? model?.placeholderText
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        onActionTap?()
    }
    
}
