//
//  ProfieHeaderView.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Kingfisher
import UIKit

struct ProfileHeaderViewModel {
    var imageUrlText: String?
    var name: String?
}

class ProfileHeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            set(name: viewModel?.name)
            set(imageUrlText: viewModel?.imageUrlText)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        xibSetup()
        nameLabel.textColor = R.color.warmGrey()
        nameLabel.font = .h2LeftBold
        profileImageView.image = R.image.avatarEmpty()
        profileImageView.roundView(radius: profileImageView.frame.width / 2)
    }

    private func set(name: String?) {
        nameLabel.text = name
    }
    
    private func set(imageUrlText: String?) {
        if let text = imageUrlText, let imageUrl = URL(string: text) {
            profileImageView.kf.setImage(with: imageUrl, placeholder: R.image.avatarEmpty())
        }
    }
}
