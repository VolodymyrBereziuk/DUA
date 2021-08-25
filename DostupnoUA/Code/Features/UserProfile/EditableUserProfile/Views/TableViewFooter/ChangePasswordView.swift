//
//  ChangePasswordView.swift
//  DostupnoUA
//
//  Created by admin on 28.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class ChangePasswordView: UIView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var oldPasswordTextView: TextFieldView!
    @IBOutlet weak var newPasswordTextView: TextFieldView!
    @IBOutlet weak var new2PasswordTextView: TextFieldView!
    @IBOutlet weak var changeButton: UIButton!
    
    var onDidChange: ((_ old: String, _ new: String) -> Void)?
    
    private var oldPass, newPass, repeatPass: String?

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
        setupAppearance()
        setupTextFieldViews()
        bindTextFieldViews()
    }

    private func setupAppearance() {
        setTexts()
        setFonts()
        borderView.backgroundColor = R.color.blueGray()?.withAlphaComponent(0.3)
        title.textColor = R.color.warmGrey()
        changeButton.addRoundShadow(color: R.color.blueGray(), radius: 9)
        changeButton.setEnablingMode(to: false)
    }
    
    private func setTexts() {
        title.text = R.string.localizable.editProfilePasswordHeader.localized()
        changeButton.setTitle(R.string.localizable.editProfilePasswordChangeButton.localized(), for: .normal)
    }
    
    private func setFonts() {
        title.font = .p1LeftBold
        changeButton.titleLabel?.font = .p2LeftBold
    }
    
    private func setupTextFieldViews () {
        oldPasswordTextView.set(placeholderText: R.string.localizable.editProfilePasswordOldPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        newPasswordTextView.set(placeholderText: R.string.localizable.editProfilePasswordNewPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        new2PasswordTextView.set(placeholderText: R.string.localizable.editProfilePasswordConfirmNewPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
    }
    
    private func bindTextFieldViews() {
        oldPasswordTextView.onEditing = { [weak self] isValid, text in
            self?.oldPass = isValid == true ? text : nil
            self?.updateButtonAppearance()
        }
        newPasswordTextView.onEditing = { [weak self] isValid, text in
            self?.newPass = isValid == true ? text : nil
            self?.updateButtonAppearance()
        }
        new2PasswordTextView.onEditing = { [weak self] isValid, text in
            self?.repeatPass = isValid == true ? text : nil
            self?.updateButtonAppearance()
        }
    }
    
    private func updateButtonAppearance() {
        let isEnabled = oldPass?.isEmpty == false && newPass?.isEmpty == false && repeatPass?.isEmpty == false && newPass == repeatPass
        changeButton.setEnablingMode(to: isEnabled)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        guard let oldPassword = oldPass, let newPassword = newPass else { return }
        onDidChange?(oldPassword, newPassword)
    }
}
