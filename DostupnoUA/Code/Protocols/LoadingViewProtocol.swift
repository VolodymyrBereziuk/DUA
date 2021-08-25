//
//  LoadingViewProtocol.swift
//  DostupnoUA
//
//  Created by Anton on 25.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

protocol LoadingViewProtocol {
    func startLoading()
    func stopLoading(error: Error?)
}

protocol LoadingPresenterProtocol: AnyObject {
    var managedLoadingView: LoadingViewProtocol? { get }
}

extension LoadingViewProtocol {
    func stopLoading(error: Error? = nil) {
        stopLoading(error: error)
    }
}
