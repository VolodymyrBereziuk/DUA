//
//  RestorePasswordViewController.swift
//  DostupnoUA
//
//  Created by Anton on 02.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol RestorePasswordNavigation {
    var toNewPassword: ((String?) -> Void)? { get set }
}

protocol RestorePasswordProtocol {
    func toNewPassword(email: String?)
}

class RestorePasswordEmailViewController: BaseViewController, RestorePasswordProtocol {
    
    var navigation: RestorePasswordNavigation?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailView: TextFieldView!
    @IBOutlet weak var restoreButton: AuthorizationButton!
    
    private var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        bindTextField()
    }
    
    private func setupAppearance() {
        setTexts()
        setFonts()
        self.navigationItem.title = R.string.localizable.restorePasswordHeaderLabelTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        restoreButton.setEnablingMode(to: false)
    }
    
    private func setTexts() {
        headerLabel.text = R.string.localizable.restorePasswordHeaderLabelTitle.localized()
        descriptionLabel.text = R.string.localizable.restorePasswordDescriptionLabelTitle.localized()
        emailView.set(placeholderText: R.string.localizable.restorePasswordEmailPlaceholder.localized(), labelsType: .formatLabel(mask: .email), rightViewType: .clear, keyboardType: .emailAddress, isSecureTextEntry: false)
        restoreButton.set(title: R.string.localizable.restorePasswordButtonTitle.localized(), gradientColors: [R.color.greenGradientTop(), R.color.greenGradientBottom()])
    }
    
    private func setFonts() {
        headerLabel.font = UIFont.h1CenteredBold
        descriptionLabel.font = UIFont.p2LeftRegular
        restoreButton.titleLabel?.font = UIFont.h2LeftBold
    }
    
    private func bindTextField() {
        emailView.onEditing = { [weak self] isValid, text in
            self?.email = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
    }
    
    private func updateRegisterButton() {
        let isEnabled = email?.isEmpty == false
        restoreButton.setEnablingMode(to: isEnabled)
    }
    
    // MARK: - Navigation
    
    @IBAction func restoreButtonAction(_ sender: UIButton) {
        toNewPassword(email: email)
    }
    
    func toNewPassword(email: String?) {
        navigation?.toNewPassword?(email)
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RestorePasswordEmailViewController {
    
    static func make(navigation: RestorePasswordNavigation) -> RestorePasswordEmailViewController? {
        let viewController = R.storyboard.restorePassword.restorePasswordEmailViewController()
        viewController?.navigation = navigation
        return viewController
    }
}
