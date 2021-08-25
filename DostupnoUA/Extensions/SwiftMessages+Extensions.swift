//
//  SwiftMessages+Extensions.swift
//  DostupnoUA
//
//  Created by admin on 10.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation
import SwiftMessages

extension SwiftMessages {

    static func show(warning: String?) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: "", body: warning ?? "")
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.duration = .seconds(seconds: 0.4)
        SwiftMessages.show(config: infoConfig, view: info)
    }
}
