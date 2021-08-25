//
//  DostupnoSearchBar.swift
//  DostupnoUA
//
//  Created by admin on 01.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class DostupnoSearchBar: UISearchBar {
    
    var onCancelTapped: (() -> Void)?
    var onStartEditing: (() -> Void)?
    var onTextEditing: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setImage(R.image.search(), for: .search, state: .normal)
        setImage(R.image.closeCircle(), for: .clear, state: .normal)
        barTintColor = .clear
        delegate = self
        
        let textField = searchForTextField(inside: self)
        textField?.backgroundColor = .white
        textField?.layer.cornerRadius = 10
        textField?.layer.borderWidth = 1
        textField?.layer.borderColor = R.color.ickyGreen()?.cgColor
        updateContentLanguage()
    }
    
    func updateContentLanguage() {
        placeholder = R.string.localizable.mapSearchPlaceholder.localized()
        updateCancelButtonContentLanguage()
    }
    
    private func updateCancelButtonContentLanguage() {
        let title = R.string.localizable.mapSearchCancelTitle.localized()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = title
    }
    
    private func searchForTextField(inside view: UIView) -> UITextField? {
        for subview in view.subviews {
            if let subview = subview as? UITextField {
                return subview
            }
            
            let textField = searchForTextField(inside: subview)
            let isFound = textField != nil
            if isFound {
                return textField
            }
            
            if view.subviews.last === subview { // check is whole array are searched
                return nil
            } else {
                continue // continue searching
            }
        }
        return nil // didn't find UITextField
    }
    
    var lastSearchedText: String?
    var textEditingTimer: Timer?
}

extension DostupnoSearchBar: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            onStartEditing?()
        }
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        clearSearchBar()
        onCancelTapped?()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func clearSearchBar() {
        text = nil
        lastSearchedText = nil
        textEditingTimer?.invalidate()
        textEditingTimer = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmptyOrWhitespace == false else {
            onStartEditing?()
            clearSearchBar()
            return
        }
        textEditingTimer?.invalidate()
        textEditingTimer = Timer.scheduledTimer(timeInterval: 0.6,
                                                target: self,
                                                selector: #selector(inputTextWait),
                                                userInfo: nil,
                                                repeats: false)
    }
    
    @objc func inputTextWait() {
        guard lastSearchedText != text else {
            return
        }
        lastSearchedText = text
        onTextEditing?(lastSearchedText)
    }
}
