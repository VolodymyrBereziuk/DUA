//
//  ScanViewController.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import AVFoundation
import UIKit

class ScanViewController: UIViewController {
    
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var qrCodeScannerView: QRScannerView!
    @IBOutlet weak var cameraDisabledAlertLabel: UILabel!
    
    fileprivate var detectedLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarView()
        qrCodeScannerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAccessToCamera { [weak self] isAuthorized in
            DispatchQueue.main.async {
                if isAuthorized {
                    self?.cameraDisabledAlertLabel.isHidden = true
                    self?.qrCodeScannerView.isHidden = false
                } else {
                    self?.qrCodeScannerView.stopScanning()
                    self?.cameraDisabledAlertLabel.isHidden = false
                    self?.qrCodeScannerView.isHidden = true
                }
            }
        }
        configureNavigationBar()
        configureViews()
        qrCodeScannerView.initSetupIfNeeded()
        if !qrCodeScannerView.isRunning {
            qrCodeScannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if qrCodeScannerView.isRunning {
            qrCodeScannerView.stopScanning()
        }
    }
    
    func configureViews() {
        cameraDisabledAlertLabel.font = .h1CenteredBold
        cameraDisabledAlertLabel.textColor = R.color.warmGrey()
        cameraDisabledAlertLabel.text = R.string.localizable.scannerReaderUnavailable.localized()
    }
    
    func openLink() {
        if let link = detectedLink, let url = URL(string: link) {
            UIApplication.shared.open(url)
            qrCodeScannerView.startScanning()
        }
    }
    
    @objc func cancelLinkView() {
        qrCodeScannerView.startScanning()
    }
    
    func configureTabBarView() {
        tabBarView.selectedTabBarItem = .scan
        tabBarView.onMapTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
        }
        tabBarView.onProfileTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 2
        }
    }

    func configureNavigationBar() {
        navigationItem.title = R.string.localizable.scannerNavigationTitle.localized()
    }
    
    func showLinkView() {
        showAlert(title: R.string.localizable.scannerQrcodeDetectedTitle.localized(),
                  cancelTitle: R.string.localizable.scannerContinue.localized(),
                  actionTitle: R.string.localizable.scannerOpenLinkBrowser.localized(),
                  cancelHandler: { [weak self] in self?.cancelLinkView() },
                  actionHandler: { [weak self] in self?.openLink() })
    }
    
    func showAlert(title: String?,
                   cancelTitle: String?,
                   actionTitle: String?,
                   cancelHandler: (() -> Void)? = nil,
                   actionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in cancelHandler?() })
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in actionHandler() })
        alert.addAction(cancelAction)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getAccessToCamera(isAuthorized: @escaping (Bool) -> Void) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            isAuthorized(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: isAuthorized)
        }
    }
}

extension ScanViewController: QRScannerViewDelegate {
    
    func qrScanningDidFail() {
        showAlert(title: R.string.localizable.scannerReaderUnavailable.localized(),
                  cancelTitle: R.string.localizable.genericCancel.localized(),
                  actionTitle: R.string.localizable.scannerSettingsTitle.localized(),
                  actionHandler: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
        })
    }
    
    func qrScanningSucceeded(with code: String) {
        detectedLink = code
        showLinkView()
    }
    
    func qrScanningDidStop() { }
}
