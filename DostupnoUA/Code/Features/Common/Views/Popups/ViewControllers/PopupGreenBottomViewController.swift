//
//  PopupGreenBottomViewController.swift
//  DostupnoUA
//
//  Created by Anton on 25.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol PopupGreenBottomNavigation {
    var toUserProfile: (() -> Void)? { get set }
}

protocol PopupGreenBottomProtocol {
    func toUserProfile()
}

class PopupGreenBottomViewController: PopupBaseViewController, PopupGreenBottomProtocol {

    struct GreenBottomPopupContent {
        let iconName: String
        let topTitle: String?
        let bottomTitle: String?
        let descriptionTitle: String?
        let buttonTitle: String?
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    
    var navigation: PopupGreenBottomNavigation?

    private var type: PopupType?

    let completeRegistration = GreenBottomPopupContent(iconName: R.image.good.name, topTitle: R.string.localizable.volunteerRegistrationComplete.localized(), bottomTitle: R.string.localizable.popupVolunteerConfirmationTitle.localized(), descriptionTitle: R.string.localizable.popupVolunteerConfirmationDescription.localized(), buttonTitle: R.string.localizable.volunteerButtonTitle.localized())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(for: type)

    }
    
    // MARK: - Appearance
    
    private func setup(for type: PopupType?) {
        closeButton.isHidden = false
        switch type {
        case .registerConfirmation :
            prepareContent(content: completeRegistration)
        case .featureInProgress, .volunteerConfirmation, .locationConfirmation:
            break
        case .none:
            break
        }
    }

    private func prepareContent(content: GreenBottomPopupContent) {
        imageView.image = UIImage(named: content.iconName)
        topLabel.text = content.topTitle
        bottomLabel.text = content.bottomTitle
        descriptionLabel.text = content.bottomTitle
        activeButton.setTitle(content.buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        toUserProfile()
    }
    
    @IBAction func activeButtonAction(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    
    func toUserProfile() {
        navigation?.toUserProfile?()
    }
}

extension PopupGreenBottomViewController {
    static func make(type: PopupType, navigation: PopupGreenBottomNavigation) -> PopupGreenBottomViewController? {
        let viewController = R.storyboard.popup.popupGreenBottomViewController()
        viewController?.type = type
        viewController?.navigation = navigation
        return viewController
    }
}
