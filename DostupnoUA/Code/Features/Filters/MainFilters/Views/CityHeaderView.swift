//
//  CityHeaderView.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//
import UIKit

class CityHeaderView: UIView {
    
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var filterTitleView: FilterTitleView!
    @IBOutlet weak var citySelectionButton: UIButton!
    
    var didTapCitySelection: (() -> Void)?
    
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
        
        filterTitleView.set(titleImage: R.image.location())
        filterTitleView.set(title: R.string.localizable.filterCitySearchTitle.localized())
        filterTitleView.set(subtitle: R.string.localizable.filterCitySearchDescription.localized())
        bottomLineView.backgroundColor = R.color.blueGray()
        bottomLineView.alpha = 0.3
        
        citySelectionButton.roundView(radius: 9, color: R.color.ickyGreen(), borderWidth: 1)
        citySelectionButton.titleLabel?.font = UIFont.p1LeftRegular
        citySelectionButton.setTitleColor(R.color.warmGrey(), for: .normal)
    }
    
    func set(cityName: String?) {
        citySelectionButton.setTitle(cityName, for: .normal)
    }
    @IBAction func selectCityTapped(_ sender: Any) {
        didTapCitySelection?()
    }
}
