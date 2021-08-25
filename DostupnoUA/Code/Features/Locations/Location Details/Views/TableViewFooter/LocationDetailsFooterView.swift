//
//  LocationDetailsFooterView.swift
//  DostupnoUA
//
//  Created by Anton on 14.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Kingfisher
import UIKit

class LocationDetailsFooterView: UIView {

    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    
    var didTapRouteButton: (() -> Void)?
    var didTapCommentButton: (() -> Void)?

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
        let image = R.image.route()?.withRenderingMode(.alwaysTemplate)
        routeButton.setTitle(R.string.localizable.locationsDetailsMakeRoute.localized(), for: .normal)

        routeButton.setImage(image, for: .normal)
        if let imView = routeButton.imageView {
            imView.tintColor = .white
            routeButton.bringSubviewToFront(imView)
        }
        commentsButton.addRoundShadow(color: R.color.blueGray(), radius: 9)
        routeButton.addRoundShadow(color: R.color.blueGray(), radius: 9)
    }
    
    func set(isCommentsAvailable: Bool) {
        commentsButton.isHidden = !isCommentsAvailable
    }
    
    // MARK: - Actions
    
    @IBAction func routeButtonTapped(_ sender: UIButton) {
        didTapRouteButton?()
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        didTapCommentButton?()
    }
    
}
