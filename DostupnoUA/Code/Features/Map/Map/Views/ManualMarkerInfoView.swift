//
//  ManualMarkerInfoView.swift
//  DostupnoUA
//
//  Created by Anton on 18.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class ManualMarkerInfoView: UIView {
    private let leftOffset: CGFloat = 15
    private let rightOffset: CGFloat = 10
    
    private let baseOriginPoint = CGPoint(x: 15, y: 15)
    private let imViewSize = CGSize(width: 18, height: 18)

    init(frame: CGRect, model: MapMarker?) {
        super.init(frame: frame)
        setupView(model: model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(model: nil)
    }
    
    private func setupView(model: MapMarker?) {
        self.backgroundColor = .clear

        let shadowViewSize = CGSize(width: self.frameWidth() - 10, height: self.frameHeight() - 10)
        let shadowView = createShadowView(size: shadowViewSize)
        self.addSubview(shadowView)
        
        let topLabelCenterY = shadowView.center.y * (2 / 3)
        let bottomLabelCenterY = shadowView.center.y * (3 / 2)
        
        let topLabelSize = CGSize(width: self.frameWidth() - (leftOffset + rightOffset), height: 35)
        let topLabel = createLabel(initRect: CGRect(origin: baseOriginPoint, size: topLabelSize), labelCenterY: topLabelCenterY, text: model?.title, font: UIFont.p1LeftBold)
        
        self.addSubview(topLabel)
        
        let offsetFromImageView: CGFloat = 10
        let bottomLabelStartX = leftOffset + imViewSize.width + offsetFromImageView
        
        let bottomLabelSize = CGSize(width: self.frameWidth() - (bottomLabelStartX + rightOffset), height: topLabelSize.height)
        
        let bottomLabel = createLabel(
            initRect: CGRect(origin: CGPoint(x: bottomLabelStartX, y: bottomLabelCenterY), size: bottomLabelSize), labelCenterY: bottomLabelCenterY, text: model?.locationTypeTitle, font: UIFont.p2LeftRegular)
        self.addSubview(bottomLabel)

        let imageView = createImageView(initRect: CGRect(origin: CGPoint(x: leftOffset, y: bottomLabel.frameY()), size: imViewSize))
        self.addSubview(imageView)
        
    }
    
    private func createLabel(initRect: CGRect, labelCenterY: CGFloat, text: String?, font: UIFont) -> UILabel {
        let label = UILabel(frame: initRect)
        label.numberOfLines = 2
        label.text = text
        label.font = font
        label.textColor = R.color.warmGrey()
        label.lineBreakMode = .byWordWrapping
//        let labelWidth = label.frameWidth()
//        let size = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
//        label.frame.size = CGSize(width: labelWidth, height: size.height)
//        label.backgroundColor = .yellow
        label.sizeToFit()
        label.setFrameHeight(height: label.frameHeight())
        label.center.y = labelCenterY
        return label
    }
    
    private func createShadowView(size: CGSize) -> UIView {
        let shadowView = UIView(frame: CGRect(origin: .zero, size: size))
        shadowView.backgroundColor = .white
        shadowView.center = self.center
        shadowView.addRoundShadow()
        return shadowView
    }
    
    private func createImageView(initRect: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: initRect)
        imageView.image = R.image.locationType()
        imageView.tintColor = R.color.slateGrey()
        imageView.center.y -= 2 //смещение для того чтобы картинка была идеально по центру с нижним лейблом
        return imageView
    }
}
