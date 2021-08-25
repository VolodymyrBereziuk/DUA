//
//  UIStoryboard+Names.swift
//  OpenWeatherMap
//
//  Created by Viktor Drykin on 13.03.2018.
//  Copyright © 2018 Viktor Drykin. All rights reserved.
//

import Foundation
import UIKit

//private let MainStoryboard = "Main"

extension UIStoryboard {
    static func mainStoryboard () -> UIStoryboard {
        return UIStoryboard()//return UIStoryboard(name: MainStoryboard, bundle: nil)
    }
}
