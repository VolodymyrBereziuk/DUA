//
//  ProfileCell.swift
//  DostupnoUA
//
//  Created by admin on 19.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class EditProfileCellViewModel {
    
    let text: String?
    let placeholderText: String?
    let labelsType: TextFieldViewLabelsType?
    let rightViewType: DostupnoTextField.RightViewType?
    let keyboardType: UIKeyboardType?
    let isSecureTextEntry: Bool?
    let isDisclosureType: Bool?
    var valueUpdate: ((String?) -> Void)?

    init(text: String?, placeholderText: String?, labelsType: TextFieldViewLabelsType? = .none, rightViewType: DostupnoTextField.RightViewType? = .none, keyboardType: UIKeyboardType? = .default, isSecureTextEntry: Bool? = false, isDisclosureType: Bool? = false, valueUpdate: ((String?) -> Void)?) {
        self.text = text
        self.placeholderText = placeholderText
        self.labelsType = labelsType
        self.rightViewType = rightViewType
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.isDisclosureType = isDisclosureType
        self.valueUpdate = valueUpdate
    }
}

class EditProfileCell: UITableViewCell {
    
    @IBOutlet weak var textView: TextFieldView!
    
    private var model: EditProfileCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        bindTextView()
    }
    
    func set(model: EditProfileCellViewModel?) {
        textView.set(placeholderText: model?.placeholderText, text: model?.text, labelsType: model?.labelsType, rightViewType: model?.rightViewType, keyboardType: model?.keyboardType ?? .default, isSecureTextEntry: model?.isSecureTextEntry ?? false)
        self.model = model
    }
    
    private func bindTextView() {
        textView.onEditing = { [weak self] isValid, text in
            if isValid {
                self?.model?.valueUpdate?(text)
            }
        }
    }
}
