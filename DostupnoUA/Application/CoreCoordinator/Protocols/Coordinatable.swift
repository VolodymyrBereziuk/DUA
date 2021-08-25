//
//  Coordinatable.swift
//  Worker Dashy
//
//  Created by Umbrella tech on 16.08.17.
//  Copyright © 2017 Umbrella. All rights reserved.
//

import Foundation

protocol Coordinatable: AnyObject {
    func start()
    func start(with option: DeepLinkOption?)
}
