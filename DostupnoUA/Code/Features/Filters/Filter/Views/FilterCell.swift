//
//  FilterCell.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var didTapLeftButton: ((IndexPath?) -> Void)?
    var didTapRightButton: ((IndexPath?) -> Void)?
    var indexPath: IndexPath?
    var model: FilterCellModel? {
        didSet {
            set(name: model?.name)
            set(nameColor: model?.nameColor)
            setLeftButton(image: model?.leftButtonImage)
            setRightButton(image: model?.rightButtonImage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetContent()
        filterNameLabel.font = UIFont.p2LeftBold
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }
    
    func resetContent() {
        leftButton.setImage(nil, for: .normal)
        leftButton.isHidden = true
        
        rightButton.setImage(nil, for: .normal)
        rightButton.isHidden = true
        
        filterNameLabel.text = ""
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        didTapLeftButton?(indexPath)
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        didTapRightButton?(indexPath)
    }
    
    func set(name: String?) {
        filterNameLabel.text = name
    }
    
    func set(nameColor: UIColor?) {
        filterNameLabel.textColor = nameColor
    }
    
    func setLeftButton(image: UIImage?) {
        if let image = image {
            leftButton.setImage(image, for: .normal)
            leftButton.isHidden = false
        } else {
            leftButton.isHidden = true
        }
    }
    
    func setRightButton(image: UIImage?) {
        if let image = image {
            rightButton.setImage(image, for: .normal)
            rightButton.isHidden = false
        } else {
            rightButton.isHidden = true
        }
    }
}
