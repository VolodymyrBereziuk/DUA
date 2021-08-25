//
//  CreationIntroViewController.swift
//  DostupnoUA
//
//  Created by admin on 09.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class CreationIntroViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressView: CreationProgressView!
    
    var state: CreationProgressView.ProgressState?
    var presenter: CreationIntroPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        progressView.state = .start
        
        navigationItem.title = R.string.localizable.locationCreationIntroNavigationTitle.localized()
        
        titleLabel.text = R.string.localizable.locationCreationIntroTitle.localized()
        titleLabel.font = .h1CenteredBold
        titleLabel.textColor = R.color.warmGrey()
        
        descriptionLabel.text = R.string.localizable.locationCreationIntroDescription.localized()
        descriptionLabel.font = .p2LeftRegular
        descriptionLabel.textColor = R.color.warmGrey()
        
        nextButton.setTitle(R.string.localizable.locationCreationIntroStartButtonTitle.localized(), for: .normal)
        nextButton.set(style: .green30)
    }
    
    @objc func backTapped() {
        presenter?.closeTapped()
    }
    
    @IBAction func nextButtonTapped(sender: Any?) {
        presenter?.nextTapped()
    }
}

extension CreationIntroViewController {
    
    static func make(with presenter: CreationIntroPresenterProtocol) -> CreationIntroViewController? {
        let viewController = R.storyboard.creationIntro.creationIntroViewController()
        viewController?.presenter = presenter
        return viewController
    }
}
