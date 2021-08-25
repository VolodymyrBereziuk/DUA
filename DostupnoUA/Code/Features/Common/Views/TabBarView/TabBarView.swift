//
//  TabBarView.swift
//  DostupnoUA
//
//  Created by admin on 05.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

enum SelectedTabBarItem {
    case scan
    case map
    case profile
}

class TabBarView: UIView {
    
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var scanContainerView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    var onScanTap: (() -> Void)?
    var onMapTap: (() -> Void)?
    var onProfileTap: (() -> Void)?
    
    var selectedTabBarItem: SelectedTabBarItem? {
        didSet {
            set(selectedTabBarItem: selectedTabBarItem)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        xibSetup()
        topLineView.backgroundColor = R.color.blueGray()
        topLineView.alpha = 0.3
        scanButton.setImage(R.image.mapScan(), for: .normal)
        mapButton.setImage(R.image.map(), for: .normal)
        profileButton.setImage(R.image.user(), for: .normal)
    }
    
    override var intrinsicContentSize: CGSize {
        let defaultTabBarHeight: CGFloat = 49
        let window = UIApplication.shared.keyWindow
        let bottomSafeAreaHeight = window?.safeAreaInsets.bottom ?? 0
        stackViewBottomConstraint.constant = bottomSafeAreaHeight
        
        return CGSize(width: window?.bounds.width ?? 0,
                      height: defaultTabBarHeight + bottomSafeAreaHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackViewBottomConstraint.constant = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    private func set(selectedTabBarItem: SelectedTabBarItem?) {
        scanButton.tintColor = R.color.blueGray()
        mapButton.tintColor = R.color.blueGray()
        profileButton.tintColor = R.color.blueGray()
        
        switch selectedTabBarItem {
        case .scan:
            scanButton.tintColor = R.color.ickyGreen()
        case .map:
            mapButton.tintColor = R.color.ickyGreen()
        case .profile:
            profileButton.tintColor = R.color.ickyGreen()
        case .none:
            break
        }
    }
    
    @IBAction func scanTapped(_ sender: Any) {
        onScanTap?()
    }
    @IBAction func mapTapped(_ sender: Any) {
        onMapTap?()
    }
    @IBAction func profileTapped(_ sender: Any) {
        onProfileTap?()
    }
    
}
