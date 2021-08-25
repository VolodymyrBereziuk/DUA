//
//  FilterTitleView.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class FilterTitleView: UIView {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

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
        
        titleImageView.tintColor = R.color.slateGrey()
        
        titleLabel.textColor = R.color.warmGrey()
        titleLabel.font = UIFont.p2LeftBold

        subtitleLabel.textColor = R.color.warmGrey()
        subtitleLabel.font = UIFont.p2LeftRegular
    }
    
    func set(titleImage: UIImage?) {
        titleImageView.image = titleImage
    }
    
    func set(title: String?) {
        titleLabel.text = title
    }
    
    func set(subtitle: String?) {
        subtitleLabel.text = subtitle
    }
}
