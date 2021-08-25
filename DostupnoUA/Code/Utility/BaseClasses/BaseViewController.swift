//
//  BaseViewController.swift
//  DostupnoUA
//
//  Created by Anton on 14.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
