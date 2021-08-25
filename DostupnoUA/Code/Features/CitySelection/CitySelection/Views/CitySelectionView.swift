//
//  CitySelectionView.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//
import UIKit

class CitySelectionView: UIView {
    
    @IBOutlet weak var cityTextFieldView: DostupnoTextField!
    @IBOutlet weak var filterTitleView: FilterTitleView!
    
    var didBeginEditing: ((String?) -> Void)?
    var onCityTextDidChange: ((String?) -> Void)?
    var didEndEditing: ((String?) -> Void)?
    
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
        cityTextFieldView.rightViewType = .clear
        cityTextFieldView.leftViewType = .whiteSpace
        
        cityTextFieldView.didBeginEditing = { [weak self] text in
            self?.didBeginEditing?(text)
        }
        cityTextFieldView.textDidChange = { [weak self] text in
            self?.onCityTextDidChange?(text)
        }
        cityTextFieldView.didEndEditing = { [weak self] text in
             self?.didEndEditing?(text)
        }
    }
    
    func set(cityName: String?) {
        cityTextFieldView.text = nil
        cityTextFieldView.placeholder = cityName
    }
}
