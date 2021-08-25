//
//  MainFilterCell.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class MainFilterCell: UITableViewCell {
    
    var model: MainFiltersModel? {
        didSet {
            set(filterName: model?.name)
            set(leftImageName: model?.imageName)
            set(isSelected: model?.isSelected)
        }
    }
    
    var didTapButton: (() -> Void)?

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImageView.tintColor = R.color.slateGrey()
        filterLabel.textColor = R.color.ickyGreen()
        filterLabel.font = UIFont.p2LeftBold
    }
    
    func set(filterName: String?) {
        filterLabel.text = filterName
    }
    
    func set(leftImageName name: String?) {
        leftImageView.image = UIImage(named: name ?? "")
    }
    
    func set(isSelected: Bool?) {
        let image = model?.isSelected == false ? R.image.forward() : R.image.closeCircle()
        actionButton.setImage(image, for: .normal)
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        didTapButton?()
    }
    
}
