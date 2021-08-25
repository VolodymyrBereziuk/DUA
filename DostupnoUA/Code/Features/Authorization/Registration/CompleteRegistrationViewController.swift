//
//  CompleteRegistrationViewController.swift
//  DostupnoUA
//
//  Created by Anton on 13.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import SwiftMessages

protocol CompleteRegistrationNavigation {
    var toUserProfile: (() -> Void)? { get set }
}

protocol CompleteRegistrationProtocol {
    func toUserProfile()
}

class CompleteRegistrationViewController: BaseViewController, CompleteRegistrationProtocol {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textField: DostupnoTextField!
    @IBOutlet weak var activateButton: AuthorizationButton!
    
    var navigation: CompleteRegistrationNavigation?
    
    private var key: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        navigationItem.title = R.string.localizable.registerNavigationBarTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        
        headerLabel.text = R.string.localizable.completeRegistrationTopLabelTitle.localized()
        descriptionLabel.text = R.string.localizable.completeRegistrationBottomLabelTitle.localized()
        
        activateButton.set(title: R.string.localizable.completeRegistrationActivateButtonTitle.localized(), gradientColors: [R.color.greenGradientTop(), R.color.greenGradientBottom()])
        activateButton.setEnablingMode(to: false)
        
        headerLabel.font = .h1CenteredBold
        descriptionLabel.font = .p2LeftRegular
        
        textField.rightViewType = .clear
        textField.leftViewType = .whiteSpace
        
        bindTextFields()
    }
    
    private func bindTextFields() {
        
        textField.textDidChange = { [weak self] text in
            self?.key = text
            self?.updateActivateButton(text: text)
        }
        
        textField.didEndOnReturn = { [weak self] text in
            guard let key = text else { return }
            if !key.isEmpty {
                self?.key = key
                self?.completeRegistration()
            }
        }
    }
    
    private func updateActivateButton(text: String?) {
        guard let key = text else { return }
        let isEnabled = !key.isEmpty
        activateButton.setEnablingMode(to: isEnabled)
    }
    
    // MARK: - API
    
    func completeRegistration() {
        ProgressView.show(in: view)
        
        let model = CompleteRegistrationParametersModel(email: email, key: key)
        let connection = CompleteRegistrationConnection(parametersModel: model)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] token in
            ProgressView.hide(for: self?.view)
            guard token.token != nil else {
                self?.showError(LoginError.tokenNil)
                return
            }
            PersistenceManager.manager.dostupnoToken = token
            //it's better to ignore the result of getUserProfile request in case of error after success registration
            self?.getUserProfile()
            }, failureHandler: { [weak self] error in
                ProgressView.hide(for: self?.view)
                self?.showError(error)
        })
    }
    
    private func getUserProfile() {
        StorageManager.shared.getUserProfile(language: LocalisationManager.shared.currentLanguage.rawValue, onSuccess: { [weak self] _ in
            self?.getUserFavouriteIDs()
            self?.toUserProfile()
        })
    }
    
    private func getUserFavouriteIDs() {
        StorageManager.shared.getUserFavouriteIDs(forceDownload: true, onSuccess: { _ in
        }, onFailure: { _ in
        })
    }
    // MARK: - Action
    
    @IBAction func activateButtonAction(_ sender: AuthorizationButton) {
        completeRegistration()
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    func toUserProfile() {
        navigation?.toUserProfile?()
    }
    
    func showError(_ error: Error) {
        SwiftMessages.show(warning: errorTitle(from: error))
    }
    
    // MARK: - Error
    func errorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case CompleteRegistrationError.wrongKey:
            message = R.string.localizable.errorCompleteRegistrationWrongKey.localized()
        case RegisterConnectionError.invalidEmail:
            message = R.string.localizable.errorCompleteRegistrationInvalidEmail.localized()
        case LoginError.tokenNil:
            message = R.string.localizable.errorUnexpectedResponse.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
}

extension CompleteRegistrationViewController {
    
    static func make(navigation: CompleteRegistrationNavigation) -> CompleteRegistrationViewController? {
        let viewController = R.storyboard.registrarion.completeRegistrationViewController()
        viewController?.navigation = navigation
        return viewController
    }
}
