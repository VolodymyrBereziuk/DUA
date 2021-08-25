//
//  VolunteerOfferView.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class VolunteerOfferView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var onActionTap: (() -> Void)?
    
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
        
        backgroundView.backgroundColor = R.color.ickyGreen()
        actionButton.layer.cornerRadius = actionButton.bounds.height / 2
        
        titleLabel.font = .h2LeftBold
        subtitleLabel.font = .p2LeftRegular
        actionButton.titleLabel?.font = .p2LeftRegular
        
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
        actionButton.backgroundColor = .white
        actionButton.setTitleColor(R.color.ickyGreen(), for: .normal)
        
        updateContentLanguage()
    }
    
    func updateContentLanguage() {
        titleLabel.text = R.string.localizable.volunteerTitle.localized()
        subtitleLabel.text = R.string.localizable.volunteerDescription.localized()
        actionButton.setTitle(R.string.localizable.volunteerButtonTitle.localized(), for: .normal)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        onActionTap?()
    }
}
