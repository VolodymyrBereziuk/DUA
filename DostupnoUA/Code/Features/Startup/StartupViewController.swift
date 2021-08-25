//
//  StartupViewController.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController, StartupViewProtocol {
    
    var isLoading = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                 activityIndicator.stopAnimating()
            }
        }
    }
    var presenter: StartupPresenterProtocol?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func present(alert: UIViewController) {
        present(alert, animated: true, completion: nil)
    }
}

extension StartupViewController {
    
    static func make(with presenter: StartupPresenterProtocol?) -> StartupViewController? {
        let viewController = R.storyboard.startup.startupViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}
