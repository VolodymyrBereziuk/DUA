//
//  PopupCoordinator.swift
//  DostupnoUA
//
//  Created by Anton on 25.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

enum PopupType {
    case registerConfirmation
    case featureInProgress(feature: FeatureInProgress)
    case locationConfirmation
    case volunteerConfirmation
    
    enum FeatureInProgress {
        case scan
        case profile
    }

}

protocol PopupCoordinatorOutput {
    var didFinish: ((_ coordinator: Coordinator) -> Void)? { get set }
    var didCancel: ((_ coordinator: Coordinator) -> Void)? { get set }
}

class PopupCoordinator: Coordinator, PopupCoordinatorOutput {

    private let storageManager: StorageManagerProtocol
    private let moduleFactory: PopupModuleFactoryProtocol
    private let popupType: PopupType
    
    var didFinish: ((Coordinator) -> Void)?
    var didCancel: ((Coordinator) -> Void)?

    init(router: Router, storageManager: StorageManagerProtocol, moduleFactory: PopupModuleFactoryProtocol, popupType: PopupType) {
        self.storageManager = storageManager
        self.moduleFactory = moduleFactory
        self.popupType = popupType
        super.init(router: router)
    }
    
    override func start(with option: DeepLinkOption?) {
        show(with: self.popupType)
    }
    
    func show(with type: PopupType) {
        switch type {
        case .registerConfirmation:
            runGreenBottomPopup(type: type)
//            runGreenBottomPopupInParentView(type: type)
        case .featureInProgress (let feature):
            switch feature {
            case .scan, .profile:
                runGenericPopupInParentView(type: type)
            }
        case .locationConfirmation:
            runTableViewPopup()
        case .volunteerConfirmation:
            runGenericPopup(type: type)
        }
    }
    
    private func runGenericPopupInParentView(type: PopupType) {
        guard let module = moduleFactory.makePopupGenericModule(type: type) else { return }
        let parentVC = router.topmostPresented()
        if let popupVC = module.toPresent(), let view = parentVC.view {
            parentVC.navigationController?.setNavigationBarHidden(true, animated: false)
            parentVC.addChild(popupVC)
            popupVC.view.frame = view.bounds
            parentVC.view.addSubview(popupVC.view)
            //    TODO: remove after v1 Mocked PopUp
            view.bringSubviewToFront(popupVC.view)
            //view.sendSubviewToBack(popupVC.view)
        }
    }
    
    func runGenericPopup(type: PopupType) {
        var hideTopBar = true
        switch type {
        case .featureInProgress (let feature):
            switch feature {
            case .scan, .profile:
                hideTopBar = true
            }
        default:
            break
        }
        guard let module = moduleFactory.makePopupGenericModule(type: type) else { return }
        router.setRootModule(module.toPresent(), hideBar: hideTopBar)
    }
    
    func runGreenBottomPopup(type: PopupType) {
        guard var module = moduleFactory.makePopupGreenBottomModule(type: type) else { return }
        module.nav.toUserProfile = { [weak self] in
            if let self = self {
                self.didFinish?(self)
            }
        }
        router.setRootModule(module.viewController, hideBar: true)
    }
    
    func runTableViewPopup() {
        guard let module = moduleFactory.makePopupTableModule() else { return }
        router.setRootModule(module.toPresent(), hideBar: true)
    }
    
}
