//
//  EmptyScreenView.swift
//  DostupnoUA
//
//  Created by admin on 19.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class EmptyScreenView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func set(title: String?, actionTitle: String?, action: (() -> Void)? = nil) {
        titleLabel.text = title

        actionButton.isHidden = action == nil
        actionButton.setTitle(actionTitle, for: .normal)
        self.action = action
    }
    
    private func setupView() {
        xibSetup()
        titleLabel.font = .h1CenteredBold
        titleLabel.textColor = R.color.warmGrey()
        actionButton.set(style: .green30)
    }
    
    @IBAction private func action(_ sender: Any) {
        action?()
    }
}
