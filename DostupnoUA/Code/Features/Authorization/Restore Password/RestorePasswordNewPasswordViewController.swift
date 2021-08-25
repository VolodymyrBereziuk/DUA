//
//  RestorePasswordNewPasswordViewController.swift
//  DostupnoUA
//
//  Created by Anton on 02.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import SwiftMessages
import UIKit

protocol RestorePasswordNewPasswordNavigation {
    var toUserProfile: (() -> Void)? { get set }
}

protocol RestorePasswordNewPasswordProtocol {
    func toUserProfile()
}

class RestorePasswordNewPasswordViewController: BaseViewController, RestorePasswordNewPasswordProtocol {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempPasswordTextField: DostupnoTextField!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordView: TextFieldView!
    @IBOutlet weak var repeatPasswordView: TextFieldView!
    @IBOutlet weak var createPasswordButton: AuthorizationButton!
    
    var navigation: RestorePasswordNewPasswordNavigation?
    var email: String?
    
    private var tempPass, newPass, repeatPass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restorePassword()
        setupAppearance()
        bindTextField()
    }
    
    private func setupAppearance() {
        setTexts()
        setFonts()
        self.navigationItem.title = R.string.localizable.restorePasswordHeaderLabelTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        createPasswordButton.setEnablingMode(to: false)
        
        tempPasswordTextField.rightViewType = .clear
        tempPasswordTextField.leftViewType = .whiteSpace
    }
    
    private func setTexts() {
        headerLabel.text = R.string.localizable.restorePasswordNewPasswordHeaderLabelTitle.localized()
        descriptionLabel.text = R.string.localizable.restorePasswordNewPasswordDescriptionLabelTitle.localized()
        newPasswordLabel.text = R.string.localizable.restorePasswordNewPasswordNewPasswordLabel.localized()
        newPasswordView.set(placeholderText: R.string.localizable.restorePasswordNewPasswordNewPassPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        repeatPasswordView.set(placeholderText: R.string.localizable.restorePasswordNewPasswordRepeatNewPassPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        tempPasswordTextField.placeholder = R.string.localizable.restorePasswordNewPasswordTempPassPlaceholder.localized()
        
        createPasswordButton.set(title: R.string.localizable.restorePasswordNewPasswordButtonTitle.localized(), gradientColors: [R.color.greenGradientTop(), R.color.greenGradientBottom()])
    }
    
    private func setFonts() {
        headerLabel.font = UIFont.h1CenteredBold
        descriptionLabel.font = UIFont.p2LeftRegular
        tempPasswordTextField.font = UIFont.p1LeftBold
        newPasswordLabel.font = UIFont.p1LeftBold
        createPasswordButton.titleLabel?.font = UIFont.h2LeftBold
    }
    
    private func bindTextField() {
        tempPasswordTextField.textDidChange = { [weak self] text in
            self?.tempPass = text
            self?.updateRegisterButton()
        }
        newPasswordView.onEditing = { [weak self] isValid, text in
            self?.newPass = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
        repeatPasswordView.onEditing = { [weak self] isValid, text in
            self?.repeatPass = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
    }
    
    private func updateRegisterButton() {
        let isEnabled = tempPass?.isEmpty == false && email?.isEmpty == false && newPass?.isEmpty == false && repeatPass?.isEmpty == false && newPass == repeatPass
        createPasswordButton.setEnablingMode(to: isEnabled)
    }
    
    // MARK: - API
    
    private func restorePassword() {
        guard let email = email else { return }
        ProgressView.show(in: view)
        let connection = RestorePasswordConnection(email: email)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] _ in
            ProgressView.hide(for: self?.view)
        }, failureHandler: { [weak self] error in
            ProgressView.hide(for: self?.view)
            SwiftMessages.show(warning: self?.restorePassswordErrorTitle(from: error))
        })
    }
    
    func updatePassword() {
        let model = ConfirmPasswordParametersModel(email: email, key: tempPass, newPassword: newPass)
        let connection = ConfirmPasswordConnection(parametersModel: model)
        ProgressView.show(in: self.view)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] token in
            if token.token != nil {
                PersistenceManager.manager.dostupnoToken = token
                self?.getUserProfile()
                print(token)
            }
        }, failureHandler: { [weak self] error in
            ProgressView.hide(for: self?.view)
            SwiftMessages.show(warning: self?.updatePasswordErrorTitle(from: error))
        })
    }
    
    private func getUserProfile() {
        StorageManager.shared.getUserProfile(language: LocalisationManager.shared.currentLanguage.rawValue, onSuccess: { [weak self] _ in
            self?.getUserFavouriteIDs()
            self?.toUserProfile()
            ProgressView.hide(for: self?.view)
        })
    }
    
    private func getUserFavouriteIDs() {
        StorageManager.shared.getUserFavouriteIDs(forceDownload: true, onSuccess: { _ in
        }, onFailure: { _ in
        })
    }
    
    // MARK: - Navigation
    
    @IBAction func createPasswordAction(_ sender: UIButton) {
        updatePassword()
    }
    
    func toUserProfile() {
        navigation?.toUserProfile?()
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Error
    
    func restorePassswordErrorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case RestorePasswordConnectionError.invalidEmail:
            message = R.string.localizable.errorResetPasswordInvalidEmail.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
    
    func updatePasswordErrorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case ConfirmPasswordError.emptyPassword:
            message = R.string.localizable.errorConfirmPasswordEmptyPassword.localized()
        case ConfirmPasswordError.weakPassword:
            message = R.string.localizable.errorConfirmPasswordWeakPassword.localized()
        case ConfirmPasswordError.wrongKey:
            message = R.string.localizable.errorConfirmPasswordWrongKey.localized()
        case ConfirmPasswordError.invalidEmail:
            message = R.string.localizable.errorConfirmPasswordInvalidEmail.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
    
}

extension RestorePasswordNewPasswordViewController {
    
    static func make(navigation: RestorePasswordNewPasswordNavigation) -> RestorePasswordNewPasswordViewController? {
        let viewController = R.storyboard.restorePassword.restorePasswordNewPasswordViewController()
        viewController?.navigation = navigation
        return viewController
    }
}
