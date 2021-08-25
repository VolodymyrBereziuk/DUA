//
//  LoginEmailViewController.swift
//  DostupnoUA
//
//  Created by Anton on 25.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit
import SwiftMessages

class LoginEmailViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var nameTextField: TextFieldView!
    @IBOutlet weak var passwordTextField: TextFieldView!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var loginButton: AuthorizationButton!
    @IBOutlet weak var recoveryPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    var presenter: LoginEmailPresenterProtocol?

    private var email: String?
    private var pass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupAppearance() {
        self.navigationItem.title = R.string.localizable.loginNavigationBarTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton

        loginButton.set(title: R.string.localizable.loginNavigationBarTitle.localized(), gradientColors: [R.color.greenGradientTop(), R.color.greenGradientBottom()])
        headerLabel.text = R.string.localizable.loginHeaderLabelTitle.localized()
        bottomLabel.text = R.string.localizable.loginBottomLabelTitle.localized()
        recoveryPasswordButton.setTitle(R.string.localizable.loginPasswordRecovery.localized(), for: .normal)
        registrationButton.setTitle(R.string.localizable.loginRegisterButtonTitle.localized(), for: .normal)
        nameTextField.set(placeholderText: R.string.localizable.loginEmailPlaceholder.localized(), labelsType: .noValidate, rightViewType: .clear)
        passwordTextField.set(placeholderText: R.string.localizable.loginPasswordPlaceholder.localized(), labelsType: .passwordLabels, rightViewType: .visible, isSecureTextEntry: true)
        loginButton.setEnablingMode(to: false)
        
        bindTextFields()
    }
    
    private func bindTextFields() {
        nameTextField.onEditing = { [weak self] isValid, text in
            self?.email = isValid == true ? text : nil
            self?.updateLoginButton()
        }
        passwordTextField.onEditing = { [weak self] isValid, text in
            self?.pass = isValid == true ? text : nil
            self?.updateLoginButton()
        }
    }
    
    private func updateLoginButton() {
        let isEnabled = email?.isEmpty == false && pass?.isEmpty == false
        loginButton.setEnablingMode(to: isEnabled)
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonAction(_ sender: AuthorizationButton) {
        ProgressView.show(in: view)
        presenter?.login(email: email, password: pass, completion: { [weak self] result in
            ProgressView.hide(for: self?.view)
            if case .failure(let error) = result {
                self?.showError(error)
            }
        })
    }
    
    @IBAction func recoveryPasswordButtonAction(_ sender: UIButton) {
        presenter?.toRestorePassword()
    }
    
    @IBAction func registrationButtonAction(_ sender: UIButton) {
        presenter?.toRegistration()
    }
        
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showError(_ error: Error) {
        SwiftMessages.show(warning: presenter?.errorTitle(from: error))
    }
}

extension LoginEmailViewController {
    
    static func make(presenter: LoginEmailPresenterProtocol?) -> LoginEmailViewController? {
        let viewController = R.storyboard.login.loginEmailViewController()
        viewController?.presenter = presenter
        return viewController
    }
}
