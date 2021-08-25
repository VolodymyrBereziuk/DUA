//
//  CommentView.swift
//  DostupnoUA
//
//  Created by admin on 19.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import Kingfisher

class CommentView: UIView {

    @IBOutlet private weak var publisherImageView: UIImageView!
    @IBOutlet private weak var publisherNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func bind(to viewModel: CommentViewModel) {
        let imagePlaceholder = R.image.avatarEmpty()
        if let text = viewModel.publisherIcon, let imageUrl = URL(string: text) {
            publisherImageView.kf.setImage(with: imageUrl, placeholder: imagePlaceholder)
        } else {
            publisherImageView.image = imagePlaceholder
        }
        publisherNameLabel.text = viewModel.publisherName
        dateLabel.text = viewModel.commentDate
        commentLabel.text = viewModel.comment
    }
    
    private func setupView() {
        xibSetup()
        dateLabel.font = .p2LeftRegular
        dateLabel.textColor = R.color.warmGrey()
        
        commentLabel.font = .p2LeftRegular
        commentLabel.textColor = R.color.warmGrey()
        
        publisherNameLabel.font = .p1LeftBold
        publisherNameLabel.textColor = R.color.warmGrey()
    }

}
