//
//  AuthorizationButton.swift
//  DostupnoUA
//
//  Created by Anton on 27.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class AuthorizationButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(title: String?, gradientColors: [UIColor?]?) {
        setTitle(title, for: .normal)
        roundView(radius: 30)
        moveImageLeftTextCenter()
        applyButtonGradient(colors: gradientColors)
    }
    
    private func moveImageLeftTextCenter(imagePadding: CGFloat = 30.0) {
        guard let imageViewWidth = self.imageView?.frame.width else { return }
        guard let titleLabelWidth = self.titleLabel?.intrinsicContentSize.width else { return }
        self.contentHorizontalAlignment = .left
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: imagePadding - imageViewWidth / 2, bottom: 0.0, right: 0.0)
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (bounds.width - titleLabelWidth) / 2 - imageViewWidth, bottom: 0.0, right: 0.0)
    }
    
}
