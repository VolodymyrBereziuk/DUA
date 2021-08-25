//
//  SearchPlacesCell.swift
//  DostupnoUA
//
//  Created by admin on 03.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class SearchPlacesCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = .p2LeftRegular
        nameLabel.textColor = R.color.warmGrey()
        placeImageView.tintColor = R.color.warmGrey()
        placeImageView.image = R.image.location()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
    }
    
    func set(name: String?) {
        nameLabel.text = name
    }
    
    func set(imageColor: UIColor?) {
        placeImageView.tintColor = imageColor
    }
    
}
