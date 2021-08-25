//
//  CreationIntroPresenter.swift
//  DostupnoUA
//
//  Created by admin on 15.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol CreationIntroNavigation {
    var didClose: (() -> Void)? { get set }
    var didNext: (() -> Void)? { get set }
}

protocol CreationIntroView: AnyObject {
    
}

protocol CreationIntroPresenterProtocol: AnyObject {
    
    var managedView: CreationIntroView? { get set }
    
    func closeTapped()
    func nextTapped()
}

class CreationIntroPresenter: CreationIntroPresenterProtocol {
    
    weak var managedView: CreationIntroView?
    var navigation: CreationIntroNavigation
        
    init(navigation: CreationIntroNavigation) {
        self.navigation = navigation
    }
    
    func closeTapped() {
        navigation.didClose?()
    }
    
    func nextTapped() {
        navigation.didNext?()
    }
}
