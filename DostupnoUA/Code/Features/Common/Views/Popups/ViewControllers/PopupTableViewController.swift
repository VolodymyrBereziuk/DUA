//
//  PopupTableViewController.swift
//  DostupnoUA
//
//  Created by Anton on 25.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class PopupTableViewController: PopupBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PopupTableViewController {
    
    static func make() -> PopupTableViewController? {
        let viewController = R.storyboard.popup.popupTableViewController()
        return viewController
    }
}
