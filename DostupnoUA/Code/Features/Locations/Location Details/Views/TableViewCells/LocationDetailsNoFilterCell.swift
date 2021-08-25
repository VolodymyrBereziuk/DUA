//
//  LocationDetailsNoFilterCell.swift
//  DostupnoUA
//
//  Created by Anton on 13.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class LocationDetailsNoFilterCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var mapButton: UIButton!
    
    var didTapMapButton: (() -> Void)?

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
        mapButton.addRoundShadow()
    }
    
    private func setupFonts() {
        nameLabel.font = UIFont.p2LeftBold
        descriptionLabel.font = UIFont.p2LeftRegular
    }
    
    // MARK: - Data
    
    func setupCell(model: NoFilterCellModel?) {
        nameLabel.text = model?.name
        descriptionLabel.text = model?.description?.isEmptyOrWhitespace == true ? R.string.localizable.locationsDetailsNoData.localized() : model?.description
        iconImageView.image = model?.iconImage
        mapButton.isHidden = !(model?.isLocation ?? false)
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        didTapMapButton?()
    }
    
}
