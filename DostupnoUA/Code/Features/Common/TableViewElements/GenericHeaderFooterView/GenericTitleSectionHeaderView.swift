//
//  GenericTitleSectionHeaderView.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

struct GenericTitleSectionHeaderViewModel {
    var title: String?
    var titleColor: UIColor?
    var isLineHidden: Bool
}

class GenericTitleSectionHeaderView: GenericHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var viewModel: GenericTitleSectionHeaderViewModel? {
        didSet {
            set(title: viewModel?.title)
            if let titleColor = viewModel?.titleColor {
                set(titleColor: titleColor)
            }
            setLine(isHidden: viewModel?.isLineHidden ?? true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addBackgroundView()
        lineView.backgroundColor = R.color.whiteGrey()
        titleLabel.font = .p1LeftBold
    }
    
    func set(title: String?) {
        titleLabel.text = title
    }
    
    func set(titleColor: UIColor?) {
        titleLabel.textColor = titleColor
    }
     
    func setLine(isHidden: Bool) {
        lineView.isHidden = isHidden
    }
}
