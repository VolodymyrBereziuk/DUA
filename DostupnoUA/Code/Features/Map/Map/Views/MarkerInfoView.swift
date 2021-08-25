//
//  MarkerInfoView.swift
//  DostupnoUA
//
//  Created by Anton on 22.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

class MarkerInfoView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var containerView: UIView!
    var didTapView: (() -> Void)?
    
    init(frame: CGRect, model: MapMarker?) {
        super.init(frame: frame)
        setupView(model: model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(model: nil)
    }
    
    private func setupFonts() {
        titleLabel.font = UIFont.p1LeftBold
        descriptionLabel.font = UIFont.p2LeftRegular
    }
    
    private func setupView(model: MapMarker?) {
        xibSetup()
        setupFonts()
        self.backgroundColor = .clear
        containerView.addRoundShadow()
        roundView(radius: containerView.layer.cornerRadius)
        titleLabel.text = model?.title
        descriptionLabel.text = model?.locationTypeTitle
    }
    
    @IBAction func tapped(_ sender: Any) {
        didTapView?()
    }
    
}
