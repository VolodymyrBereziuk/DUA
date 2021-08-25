//
//  LoginViewController.swift
//  DostupnoUA
//
//  Created by Anton on 30.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit
import SwiftMessages

class LoginViewController: UIViewController, LoginViewProtocol {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var appleButton: AuthorizationButton!
    @IBOutlet weak var facebookButton: AuthorizationButton!
    @IBOutlet weak var gmailButton: AuthorizationButton!
    @IBOutlet weak var emailButton: AuthorizationButton!
    
    @IBOutlet weak var registrationButton: UIButton!
    
    var presenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        SocialLoginManager.shared.delegate = self
        
    }
    
    private func setupAppearance() {
        navigationItem.title = R.string.localizable.loginNavigationBarTitle.localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        if #available(iOS 13.0, *) {
            appleButton.isHidden = false
            appleButton.set(title: R.string.localizable.loginApple.localized(), gradientColors: [.black, .black])
            appleButton.setTitleColor(.white, for: .normal)
        } else {
            appleButton.isHidden = true
        }
        facebookButton.set(title: R.string.localizable.loginFacebook.localized(), gradientColors: [R.color.blueGradientTop(), R.color.blueGradientBottom()])
        gmailButton.set(title: R.string.localizable.loginGoogle.localized(), gradientColors: [R.color.redGradientTop(), R.color.redGradientBottom()])
        emailButton.set(title: R.string.localizable.loginEmail.localized(), gradientColors: [R.color.greenGradientTop(), R.color.greenGradientBottom()])
        headerLabel.text = R.string.localizable.loginHeaderLabelTitle.localized()
        firstLabel.text = R.string.localizable.loginTopLabelTitle.localized()
        bottomLabel.text = R.string.localizable.loginBottomLabelTitle.localized()
        registrationButton.setTitle(R.string.localizable.loginRegisterButtonTitle.localized(), for: .normal)
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func appleButtonAction(_ sender: Any) {
        SocialLoginManager.shared.authorize(with: .apple, viewController: self)
    }
    
    @IBAction func facebookButtonAction(_ sender: AuthorizationButton) {
        SocialLoginManager.shared.authorize(with: .facebook, viewController: self)
    }
    
    @IBAction func gmailButtonAction(_ sender: AuthorizationButton) {
        SocialLoginManager.shared.authorize(with: .google, viewController: self)
    }
    
    @IBAction func emailButtonAction(_ sender: AuthorizationButton) {
        presenter?.toLoginEmail()
    }
    
    @IBAction func registrationButtonAction(_ sender: UIButton) {
        presenter?.toRegistration()
    }
    
    func showError(_ error: Error) {
        let message = presenter?.errorTitle(from: error)
        SwiftMessages.show(warning: message)
    }
}

extension LoginViewController: SocialLoginManagerDelegate {
    
    func returnNetworkData(token: String, typeSocial: SocialNetworkType) {
        ProgressView.show(in: view)
        presenter?.login(token: token, typeSocial: typeSocial, completion: { [weak self] result in
            ProgressView.hide(for: self?.view)
            if case .failure(let error) = result {
                self?.showError(error)
            }
        })
    }
}

extension LoginViewController {
    
    static func make(presenter: LoginPresenterProtocol?) -> LoginViewController? {
        let viewController = R.storyboard.login.loginViewController()
        viewController?.presenter = presenter
        viewController?.presenter?.managedView = viewController
        return viewController
    }
}
