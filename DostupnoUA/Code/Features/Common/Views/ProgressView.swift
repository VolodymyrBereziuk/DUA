//
//  ProgressView.swift
//  DostupnoUA
//
//  Created by admin on 01.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation
import MBProgressHUD

struct ProgressView {
    
    static func show(in view: UIView) {
        let indicator = MBProgressHUD.showAdded(to: view, animated: true)
        indicator.animationType = .fade
        indicator.contentColor = R.color.ickyGreen()
    }
    
    //show be the same view as shown (rewrite in better way, using protocol)
    static func hide(for view: UIView?) {
        guard let view = view else { return }
        MBProgressHUD.hide(for: view, animated: true)
    }
    
}
