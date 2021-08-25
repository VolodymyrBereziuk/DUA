//
//  RegistrationViewController.swift
//  DostupnoUA
//
//  Created by Anton on 25.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import SwiftMessages
import UIKit

protocol RegisterNavigation {
    var toCompleteRegistration: ((String?) -> Void)? { get set }
}

protocol RegistrationProtocol {
    func toCompleteRegistration(email: String?)
}

class RegistrationViewController: UIViewController, RegistrationProtocol {
    
    var navigation: RegisterNavigation?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameTextField: TextFieldView!
    @IBOutlet weak var emailTextField: TextFieldView!
    @IBOutlet weak var passwordTextField: TextFieldView!
    @IBOutlet weak var repeatPasswordTextField: TextFieldView!
    @IBOutlet weak var registrationButton: AuthorizationButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var confirmRulesButton: UIButton!
    @IBOutlet weak var confirmRulesTextView: UITextView!
    
    private var name: String?
    private var email: String?
    private var pass: String?
    private var repeatPass: String?
    private var rulesIsConfirmed = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupHideKeyboardOnTap()
        bindTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupAppearance() {
        self.navigationItem.title = R.string.localizable.registerNavigationBarTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        
        headerLabel.text = R.string.localizable.registerHeaderLabelTitle.localized()
        descriptionLabel.text = R.string.localizable.registerTopLabelTitle.localized()
        bottomLabel.text = R.string.localizable.registerBottomLabelTitle.localized()
        loginButton.setTitle(R.string.localizable.registerLoginButtonTitle.localized(), for: .normal)
        
        nameTextField.set(placeholderText: R.string.localizable.registerNamePlaceholder.localized(), labelsType: .noValidate, rightViewType: .clear)
        emailTextField.set(placeholderText: R.string.localizable.registerEmailPlaceholder.localized(), labelsType: .formatLabel(mask: .email), rightViewType: .clear, keyboardType: .emailAddress)
        passwordTextField.set(placeholderText: R.string.localizable.registerCreatePasswordPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        repeatPasswordTextField.set(placeholderText: R.string.localizable.registerRepeatPasswordPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        
        registrationButton.set(title: R.string.localizable.registerRegisterButtonTitle.localized(), gradientColors: [R.color.greenGradientTop(), R.color.greenGradientBottom()])
        registrationButton.setEnablingMode(to: false)
        setupRulesTextView()
    }
    
    private func setupRulesTextView() {
        let totalText = R.string.localizable.registerUserAgreementTotalText.localized()
        let linkText = R.string.localizable.registerUserAgreementLinkText.localized()
        let userAgreementUrl = R.string.localizable.linkRegistrationUserAgreement.localized()

        let attributedString = NSMutableAttributedString(string: totalText)
        let totalRange = attributedString.mutableString.range(of: totalText)
        let foundRange = attributedString.mutableString.range(of: linkText)
        let font = UIFont.p2LeftRegular
        let linkFont = UIFont.p2LeftBold
        let fontColor: UIColor = R.color.warmGrey() ?? .gray
        let linkColor: UIColor = R.color.ickyGreen() ?? .green
        
        attributedString.addAttributes([.font: font, .foregroundColor: fontColor], range: totalRange)

        guard let url = URL(string: userAgreementUrl) else { return }
        attributedString.addAttributes([.link: url, .font: linkFont, .foregroundColor: linkColor], range: foundRange)
        
        confirmRulesTextView.attributedText = attributedString
        confirmRulesTextView.linkTextAttributes = [.foregroundColor: linkColor]
        confirmRulesTextView.delegate = self
    }
    
    private func bindTextFields() {
        nameTextField.onEditing = { [weak self] isValid, text in
            self?.name = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
        emailTextField.onEditing = { [weak self] isValid, text in
            self?.email = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
        passwordTextField.onEditing = { [weak self] isValid, text in
            self?.pass = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
        repeatPasswordTextField.onEditing = { [weak self] isValid, text in
            self?.repeatPass = isValid == true ? text : nil
            self?.updateRegisterButton()
        }
    }
    
    private func updateRegisterButton() {
        let isEnabled = rulesIsConfirmed == true && name?.isEmpty == false && email?.isEmpty == false && pass?.isEmpty == false && repeatPass?.isEmpty == false && pass == repeatPass
        registrationButton.setEnablingMode(to: isEnabled)
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //переход на LoginViewController
    }
    
    @IBAction func registrationButtonAction(_ sender: AuthorizationButton) {
        ProgressView.show(in: view)
        let model = RegisterConnectionParametersModel(email: email, pass: pass, name: name)
        let connection = RegisterConnection(parametersModel: model)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] response in
            ProgressView.hide(for: self?.view)
            if response.success == true {
                self?.toCompleteRegistration(email: self?.email)
            } else {
                //TODO: check why response is bool value
                self?.showError(NSError(domain: "", code: 666, userInfo: nil))
            }
            }, failureHandler: { [weak self] error in
                ProgressView.hide(for: self?.view)
                self?.showError(error)
        })
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmRulesAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        rulesIsConfirmed = sender.isSelected
        updateRegisterButton()
    }
    
    // MARK: - Navigation
    func toCompleteRegistration(email: String?) {
        navigation?.toCompleteRegistration?(email)
    }
    
    func showError(_ error: Error) {
        SwiftMessages.show(warning: errorTitle(from: error))
    }
    
    // MARK: - Error
    // swiftlint:disable:next cyclomatic_complexity
    func errorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case RegisterConnectionError.nameIsEmpty:
            message = R.string.localizable.errorRegisterEmptyName.localized()
        case RegisterConnectionError.invalidEmail:
            message = R.string.localizable.errorRegisterInvalidEmail.localized()
        case RegisterConnectionError.userExists:
            message = R.string.localizable.errorRegisterUserExist.localized()
        case RegisterConnectionError.emptyPassword:
            message = R.string.localizable.errorRegisterEmptyPassword.localized()
        case RegisterConnectionError.weakPassword:
            message = R.string.localizable.errorRegisterWeakPassword.localized()
        case RegisterConnectionError.badConfig:
            message = R.string.localizable.errorRegisterBadConfig.localized()
        case RegisterConnectionError.badRequestEmail:
            message = R.string.localizable.errorRegisterBadEmail.localized()
        case RegisterConnectionError.badRequestPassword:
            message = R.string.localizable.errorRegisterBadPasssword.localized()
        case RegisterConnectionError.badRequestFbToken:
            message = R.string.localizable.errorRegisterFb.localized()
        case RegisterConnectionError.fbToken:
            message = R.string.localizable.errorRegisterFb.localized()
        case LoginConnectionError.googleToken:
            message = R.string.localizable.errorRegisterGoogle.localized()
        case LoginConnectionError.appleToken:
            message = R.string.localizable.errorRegisterApple.localized()
        case LoginError.tokenNil:
            message = R.string.localizable.errorUnexpectedResponse.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
}

extension RegistrationViewController {
    
    static func make(navigation: RegisterNavigation) -> RegistrationViewController? {
        let viewController = R.storyboard.registrarion.registrationViewController()
        viewController?.navigation = navigation
        return viewController
    }
}

extension RegistrationViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let webViewController = WebViewController(urlString: URL.absoluteString)
        navigationController?.show(webViewController, sender: nil)
        return false
    }
}
