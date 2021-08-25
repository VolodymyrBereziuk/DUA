//
//  PopupGenericViewController.swift
//  DostupnoUA
//
//  Created by Anton on 25.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

struct PopupContent {
    let iconName: String
    let topTitle: String?
    let bottomTitle: String?
}

class PopupGenericViewController: PopupBaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var type: PopupType?
    
    let scanFeatureInProgress = PopupContent(iconName: R.image.scan.name, topTitle: R.string.localizable.popupScanInProgressTitle.localized(), bottomTitle: R.string.localizable.popupScanInProgressDescription.localized())
    let volunteerConfirmation = PopupContent(iconName: R.image.good.name, topTitle: R.string.localizable.popupVolunteerConfirmationTitle.localized(), bottomTitle: R.string.localizable.popupVolunteerConfirmationDescription.localized())
    let profileFeatureInProgress = PopupContent(iconName: R.image.profile.name, topTitle: R.string.localizable.popupScanInProgressTitle.localized(), bottomTitle: R.string.localizable.popupProfileInProgressDescription.localized())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(for: type)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Appearance
    
    private func setup(for type: PopupType?) {
        closeButton.isHidden = false
        switch type {
        case .registerConfirmation, .locationConfirmation :
            break
        case .featureInProgress (let feature):
            switch feature {
            case .scan:
                closeButton.isHidden = true
                prepareContent(content: scanFeatureInProgress)
            case .profile:
                closeButton.isHidden = true
                prepareContent(content: profileFeatureInProgress)
            }
        case .volunteerConfirmation:
            prepareContent(content: volunteerConfirmation)
        case .none:
            break
        }
    }

    private func prepareContent(content: PopupContent) {
        imageView.image = UIImage(named: content.iconName)
        titleLabel.text = content.topTitle
        descriptionLabel.text = content.bottomTitle
    }
    
    // MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PopupGenericViewController {
    
    static func make(type: PopupType) -> PopupGenericViewController? {
        let viewController = R.storyboard.popup.popupGenericViewController()
        viewController?.type = type
        return viewController
    }
}
