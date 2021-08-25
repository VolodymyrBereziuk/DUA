//
//  LocationDetailsThreeFilterCell.swift
//  DostupnoUA
//
//  Created by Anton on 13.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class LocationDetailsThreeFilterCell: UITableViewCell {
    
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var firstFilterTitle: UILabel!
    @IBOutlet weak var firstFilterDescription: UILabel!
    
    @IBOutlet weak var secondFilterTitle: UILabel!
    @IBOutlet weak var secondFilterDescription: UILabel!
    
    @IBOutlet weak var thirdFilterTitle: UILabel!
    @IBOutlet weak var thirdFilterDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Appearance
    
    private func setupView() {
        setupFonts()
        gradeView.layer.cornerRadius = 6
        gradeView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupFonts() {
        nameLabel.font = UIFont.p2LeftBold
        descriptionLabel.font = UIFont.p2LeftRegular
        
        [firstFilterTitle, secondFilterTitle, thirdFilterTitle].forEach { $0?.font = UIFont.p3LeftBold }
        [firstFilterDescription, secondFilterDescription, thirdFilterDescription].forEach { $0?.font = UIFont.p3LeftRegular }
    }
    
    // MARK: - Data

    func setupCell(model: ThreeFilterCellModel?) {
        nameLabel.text = model?.name
        descriptionLabel.text = model?.description?.isEmptyOrWhitespace == true ? R.string.localizable.locationsDetailsNoData.localized() : model?.description
        firstFilterTitle.text = model?.firstFilterTitle
        firstFilterDescription.text = model?.firstFilterDescription?.isEmptyOrWhitespace == true ? R.string.localizable.locationsDetailsNoData.localized() : model?.firstFilterDescription
        secondFilterTitle.text = model?.secondFilterTitle
        secondFilterDescription.text = model?.secondFilterDescription?.isEmptyOrWhitespace == true ? R.string.localizable.locationsDetailsNoData.localized() : model?.secondFilterDescription
        thirdFilterTitle.text = model?.thirdFilterTitle
        thirdFilterDescription.text = model?.thirdFilterDescription?.isEmptyOrWhitespace == true ? R.string.localizable.locationsDetailsNoData.localized() : model?.thirdFilterDescription
        iconImageView.image = model?.iconImage
        gradeView.backgroundColor = model?.gradeColor
    }
}
