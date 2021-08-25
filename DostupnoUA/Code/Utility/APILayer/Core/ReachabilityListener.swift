//
//  ReachabilityListener.swift
//  DostupnoUA
//
//  Created by admin on 23.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Alamofire
import SwiftMessages

class ReachabilityListener {
    
    static let shared = ReachabilityListener()
    
    private init() {
        reachabilityManager = Alamofire.NetworkReachabilityManager.default
    }
    
    private let reachabilityManager: NetworkReachabilityManager?
    private var isReachable = true
    
    func startListening() {
        reachabilityManager?.startListening { [weak self] status in
            switch status {
            case .notReachable :
                self?.getNotReachable()
            case .reachable(.cellular), .reachable(.ethernetOrWiFi) :
                self?.getReachable()
            default :
                break
            }
            
        }
    }
    
    private func getNotReachable() {
        if isReachable {
            isReachable.toggle()
            showAlert(isReachable: isReachable)
        }
    }
    
    private func getReachable() {
        if isReachable == false {
            isReachable.toggle()
            showAlert(isReachable: isReachable)
        }
    }
    
    private func showAlert(isReachable: Bool) {
        let message = isReachable
            ? R.string.localizable.networkReachabilityAvailable.localized()
            : R.string.localizable.networkReachabilityUnavailable.localized()
        SwiftMessages.show(warning: message)
    }
    
}
