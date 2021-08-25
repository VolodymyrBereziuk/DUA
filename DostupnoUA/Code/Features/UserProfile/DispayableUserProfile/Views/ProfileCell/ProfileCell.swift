//
//  ProfileCell.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

struct ProfileCellViewModel {
    
    let title: String?
    var action: (() -> Void)?
    let titleColor: UIColor?
    let isSelectable: Bool
    let image: UIImage?
    
    init(title: String?, titleColor: UIColor?, action: (() -> Void)? = nil, isSelectable: Bool = true, image: UIImage?) {
        self.title = title
        self.titleColor = titleColor
        self.action = action
        self.isSelectable = isSelectable
        self.image = image
    }
}

class ProfileCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: ProfileCellViewModel? {
        didSet {
            set(title: viewModel?.title)
            set(titleColor: viewModel?.titleColor)
            set(image: viewModel?.image)
            selectionStyle = viewModel?.isSelectable == true ? .default : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        itemImageView.tintColor = R.color.warmGrey()
        nameLabel.font = .p2LeftBold
    }
    
    func set(image: UIImage?) {
        itemImageView.image = image
    }
    
    func set(title: String?) {
        nameLabel.text = title
    }
    
    func set(titleColor: UIColor?) {
        nameLabel.textColor = titleColor
    }
}
