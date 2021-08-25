//
//  StartupPresenter.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Foundation
import SwiftMessages

protocol StartupNavigation {
    var onFinish: ((_ showLoginScreen: Bool) -> Void)? { get set }
}

protocol StartupViewProtocol: AnyObject {
    var isLoading: Bool { get set }
    
    func present(alert: UIViewController)
}

protocol StartupPresenterProtocol: AnyObject {
    var managedView: StartupViewProtocol? { get set }
    
    func viewDidLoad()
}

class StartupPresenter: StartupPresenterProtocol {
    
    weak var managedView: StartupViewProtocol?
    
    let navigation: StartupNavigation
    var downloadGroup = DispatchGroup()
    
    enum DownloadStatus {
        case success
        case notSuccess
    }
    
    var filterDownloadStatus = DownloadStatus.notSuccess
    var configDownloadStatus = DownloadStatus.notSuccess
    private var refreshTokenExpired = false

    var needAppUpdate = false
    
    init(navigation: StartupNavigation) {
        self.navigation = navigation
        setupAPIClient()
    }
    
    func viewDidLoad() {
        downloadData()
    }
    
    private func setupAPIClient() {
        let interceptor = RequestInterceptor(logoutAction: logoutAction)
        APIClient.interceptor = interceptor
    }
    
    func downloadData() {
        filterDownloadStatus = DownloadStatus.notSuccess
        configDownloadStatus = DownloadStatus.notSuccess
        needAppUpdate = false
        managedView?.isLoading = true
        downloadGroup = DispatchGroup()
        downloadFilters()
        downloadConfig()
        if PersistenceManager.manager.isLoggedIn {
            downloadUserProfile()
            downloadUserFavouriteIDs()
        }
        downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.managedView?.isLoading = false
            let successfulDownload = self?.filterDownloadStatus == .success && self?.configDownloadStatus == .success
            guard successfulDownload else {
                SwiftMessages.show(warning: R.string.localizable.genericErrorUnknown.localized())
                self?.showFailedDownloadAlert()
                return
            }
            guard self?.needAppUpdate == false else {
                self?.showUpdateAppAlert()
                return
            }
            let needShowLogout = self?.refreshTokenExpired ?? false
            self?.navigation.onFinish?(needShowLogout)
        }
    }
    
    func downloadFilters() {
        downloadGroup.enter()
        StorageManager.shared.getFilters(language: LocalisationManager.shared.currentLanguage.rawValue, onSuccess: { [weak self] _ in
            self?.filterDownloadStatus = .success
            self?.downloadGroup.leave()
            }, onFailure: { [weak self] _ in
                self?.downloadGroup.leave()
        })
    }
    
    func downloadConfig() {
        downloadGroup.enter()
        APIClient.shared.start(connection: GetConfigConnection(), successHandler: { [weak self] config in
            self?.configDownloadStatus = .success
            self?.needAppUpdate = VersionComparator.isUpdateNeeded(minVersion: config.version?.ios)
            self?.downloadGroup.leave()
            }, failureHandler: { [weak self] _ in
                self?.downloadGroup.leave()
        })
    }
    
    func downloadUserProfile() {
        downloadGroup.enter()
        StorageManager.shared.getUserProfile(forceDownload: true, onSuccess: { [weak self] _ in
            self?.downloadGroup.leave()
        }, onFailure: { [weak self] _ in
            self?.downloadGroup.leave()
        })
    }
    
    func downloadUserFavouriteIDs() {
        downloadGroup.enter()
        StorageManager.shared.getUserFavouriteIDs(forceDownload: true, onSuccess: { [weak self] _ in
            self?.downloadGroup.leave()
        }, onFailure: { [weak self] _ in
            self?.downloadGroup.leave()
        })
    }
    
    private func logoutAction() {
        PersistenceManager.manager.logout()
        StorageManager.shared.clearContent()
        refreshTokenExpired = true
    }
    
    func showFailedDownloadAlert() {
        let title = R.string.localizable.startupDownloadErrorTitle.localized()
        let message = R.string.localizable.startupDownloadErrorMessage.localized()
        let actionTitle = R.string.localizable.startupDownloadErrorActionTitle.localized()
        
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
            self?.downloadData()
        }
        let alert = makeAlert(title: title, message: message, action: action)
        managedView?.present(alert: alert)
    }
    
    func showUpdateAppAlert() {
        let title = R.string.localizable.startupLowVersionErrorTitle.localized()
        let actionTitle = R.string.localizable.startupLowVersionErrorActionTitle.localized()
        
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
            self?.downloadData()
        }
        let alert = makeAlert(title: title, action: action)
        managedView?.present(alert: alert)
    }
    
    func makeAlert(title: String, message: String? = nil, action: UIAlertAction) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        return alert
    }
}
