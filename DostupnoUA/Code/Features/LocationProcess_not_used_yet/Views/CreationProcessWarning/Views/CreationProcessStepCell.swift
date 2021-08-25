//
//  CreationProcessStepCell.swift
//  DostupnoUA
//
//  Created by admin on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class CreationProcessStepViewModel {
    let leftImage: UIImage?
    let title: String?
    var isDone: Bool
    
    init(leftImage: UIImage?, title: String?, isDone: Bool) {
        self.leftImage = leftImage
        self.title = title
        self.isDone = isDone
    }
}

class CreationProcessStepCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var processImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.p2LeftRegular
        titleLabel.textColor = R.color.warmGrey()
        leftImageView.tintColor = R.color.warmGrey()
        processImageView.image = R.image.check()
        processImageView.tintColor = R.color.warmGrey()
    }
    
    private var isDone = false {
        didSet {
            processImageView.tintColor = isDone ? R.color.ickyGreen() : R.color.warmGrey()
        }
    }
    
    func setProcessImage(isHidden: Bool) {
        processImageView.isHidden = isHidden
    }
    
    func adjust(to viewModel: CreationProcessStepViewModel) {
        titleLabel.text = viewModel.title
        leftImageView.image = viewModel.leftImage
        isDone = viewModel.isDone
    }
}
