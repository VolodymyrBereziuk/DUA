//
//  LocationListCVCell.swift
//  DostupnoUA
//
//  Created by Anton on 13.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class LocationListCVCell: UICollectionViewCell {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Appearance
    
    private func setupView() {
        circleView.roundView(radius: circleView.frame.size.width / 2)
        nameLabel.font = UIFont.p2LeftRegular
    }
    
    // MARK: - Data
    
    func setupCell(model: LocationListCVCellModel?) {
        nameLabel.text = model?.name
        circleView.backgroundColor = model?.gradeColor
    }
}
