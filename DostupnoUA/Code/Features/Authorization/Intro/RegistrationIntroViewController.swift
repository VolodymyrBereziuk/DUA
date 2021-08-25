//
//  RegistrationIntroViewController.swift
//  DostupnoUA
//
//  Created by admin on 16.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol RegistrationIntroNavigation {
    var toRegistrationScreen: (() -> Void)? { get set }
}

class RegistrationIntroViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var aboutDostupnoButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var tabBarView: TabBarView!
    
    var navigation: RegistrationIntroNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureTabBarView()
        setLocalizedTexts()
    }
    
    func setLocalizedTexts() {
        titleLabel.text = R.string.localizable.registerIntroTitle.localized()
        subtitleLabel.text = R.string.localizable.registerIntroSubtitle.localized()
        navigationItem.title = R.string.localizable.genericAboutDostupnoTitle.localized()
        aboutDostupnoButton.setTitle(R.string.localizable.genericAboutDostupnoTitle.localized(), for: .normal)
        supportButton.setTitle(R.string.localizable.genericSupportDostupnoTitle.localized(), for: .normal)
        registrationButton.setTitle(R.string.localizable.registerNavigationBarTitle.localized(), for: .normal)
    }
    
    func configureViews() {
        titleLabel.font = .h1CenteredBold
        titleLabel.textColor = R.color.warmGrey()
        subtitleLabel.font = .p1LeftBold
        subtitleLabel.textColor = R.color.warmGrey()
        aboutDostupnoButton.set(style: .green30)
        supportButton.set(style: .green30)
        registrationButton.set(style: .green30)
    }

    @IBAction func aboutDostupnoTapped(_ sender: Any) {
        let urlAddress = R.string.localizable.linkAboutDostupno.localized()
        showWebView(by: urlAddress, title: aboutDostupnoButton.titleLabel?.text)
    }
    @IBAction func supportTapped(_ sender: Any) {
        let urlAddress = R.string.localizable.linkSupportDostupno.localized()
        showWebView(by: urlAddress, title: supportButton.titleLabel?.text)
        
    }
    @IBAction func registrationTapped(_ sender: Any) {
        navigation?.toRegistrationScreen?()
    }
    
    func showWebView(by urlAddress: String, title: String?) {
        let webViewController = WebViewController(urlString: urlAddress, title: title)
        navigationController?.show(webViewController, sender: nil)
    }
    
    func configureTabBarView() {
        tabBarView.selectedTabBarItem = .profile
        tabBarView.onScanTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
        tabBarView.onMapTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
        }
    }
}

extension RegistrationIntroViewController {
    
    static func make(navigation: RegistrationIntroNavigation) -> RegistrationIntroViewController? {
        let viewController = R.storyboard.registrationIntro.registrationIntroViewController()
        viewController?.navigation = navigation
        return viewController
    }
}
