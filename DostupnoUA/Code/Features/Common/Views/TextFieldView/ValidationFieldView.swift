//
//  TextFieldView.swift
//  DostupnoUA
//
//  Created by Anton on 30.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

enum TextFieldViewLabelsType {
    case passwordLabels
    case formatLabel(mask: ValidateMask)
    case noValidate
}

enum ValidateMask: String {
    case email = "name@mail.com"
    case phone = "+380 00 000 00 00"
    //    case userMask(mask: String)
}

protocol TextFieldViewProtocol: AnyObject {
//    var text: String? { get }
}

class TextFieldView: UIView, TextFieldViewProtocol {
    
    @IBOutlet weak var greenBorderTextField: DostupnoTextField!
    
    @IBOutlet weak var passwordLabelsView: UIView!
    @IBOutlet weak var formatLabelView: UIView!
    
    @IBOutlet weak var passwordCountSymbolsImageView: UIImageView!
    @IBOutlet weak var passwordCountSymbolsLabel: UILabel!
    
    @IBOutlet weak var passwordUppercaseImageView: UIImageView!
    @IBOutlet weak var passwordUppercaseLabel: UILabel!

    @IBOutlet weak var passwordDigitImageView: UIImageView!
    @IBOutlet weak var passwordDigitLabel: UILabel!
    @IBOutlet var imageViews: [UIImageView]!
    
    @IBOutlet weak var formatImageView: UIImageView!
    @IBOutlet weak var formatLabel: UILabel!
    
    private var labelsType: TextFieldViewLabelsType? = .none
    private var validateMaskType: ValidateMask = .email
    
    private let defaultIconTintColor = R.color.blueGray()
    private let defaultTextColor = R.color.greyishBrown()
    private let errorColor = R.color.grapefruit()
    private let validColor = R.color.ickyGreen()
    
    typealias ValidationFieldViewCallback = ((Bool, String?) -> Void)
    
    var onEditing: ValidationFieldViewCallback?
//    var text: String? {
//        return currentText
//    }
//    private var currentText: String?
    
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
        passwordCountSymbolsLabel.text = R.string.localizable.loginPasswordLimitCharactersAmount.localized()
        passwordUppercaseLabel.text = R.string.localizable.loginPasswordLimitUppercase.localized()
        passwordDigitLabel.text = R.string.localizable.loginPasswordLimitNumbers.localized()
        passwordLabelsView.isHidden = true
        formatLabelView.isHidden = true
        greenBorderTextField.delegate = self
        if #available(iOS 13.0, *) {
            // in ios 13 available new textfield delegate textFieldDidChangeSelection
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: UITextField.textDidChangeNotification, object: greenBorderTextField)
        }
        imageViews.forEach { imageView in
            imageView.image = R.image.check()?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = defaultIconTintColor
        }
    }
    
    func set(placeholderText: String?,
             text: String? = nil,
             labelsType: TextFieldViewLabelsType? = .none,
             rightViewType: DostupnoTextField.RightViewType? = .none,
             keyboardType: UIKeyboardType = .default,
             isSecureTextEntry: Bool = false) {
        setLabelsType(labelsType: labelsType)
        greenBorderTextField.rightViewType = rightViewType
        greenBorderTextField.placeholder = placeholderText
        greenBorderTextField.keyboardType = keyboardType
        greenBorderTextField.isSecureTextEntry = isSecureTextEntry
        greenBorderTextField.text = text
    }
    
    private func setLabelsType(labelsType: TextFieldViewLabelsType?) {
        self.labelsType = labelsType
        switch labelsType {
        case .passwordLabels:
            passwordLabelsView.isHidden = false
        case .formatLabel(let mask):
            let str = R.string.localizable.validationTextFieldFormat.localized() + " " + mask.rawValue
            formatLabel.text = str
            formatLabelView.isHidden = false
        case .noValidate:
            passwordLabelsView.isHidden = true
            formatLabel.isHidden = true
        case .none:
            break
        }
    }
    
}

extension TextFieldView: UITextFieldDelegate {
    
    @objc func updateText(notification: NSNotification) {
        if let textField = notification.object as? DostupnoTextField {
            validate(text: textField.text)
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        validate(text: textField.text)
    }
    
    private func validate(text: String?) {
        switch labelsType {
        case .passwordLabels:
            guard let validateResult = text?.isValidPassword() else { return }
            passwordCountSymbolsImageView.tintColor = validateResult.lenght ? validColor : defaultIconTintColor
            passwordUppercaseImageView.tintColor = validateResult.oneUppercase ? validColor : defaultIconTintColor
            passwordDigitImageView.tintColor = validateResult.oneDigit ? validColor : defaultIconTintColor
            let isPassValid = validateResult.lenght == true && validateResult.oneUppercase == true && validateResult.oneDigit == true
            onEditing?(isPassValid, text)
        case .formatLabel(let mask):
            if mask == .email {
                let textFieldText = text ?? ""
                let isValid = textFieldText.isEmpty ? true : (text?.isValidEmail() ?? false)
                formatImageView.tintColor = isValid ? validColor : errorColor
                formatLabel.textColor = isValid ? defaultTextColor : errorColor
                onEditing?(isValid, text)
            } else if mask == .phone {
                let textFieldText = text ?? ""
                let isValid = textFieldText.isEmpty ? true : (text?.isValidPhone() ?? false)
                formatImageView.tintColor = isValid ? validColor : errorColor
                formatLabel.textColor = isValid ? defaultTextColor : errorColor
                onEditing?(isValid, text)
            }
        case .noValidate:
            onEditing?(true, text)
        case .none:
            break
        }
    }
}
