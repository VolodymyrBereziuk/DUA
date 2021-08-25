//
//  DostupnoTextField.swift
//  DostupnoUA
//
//  Created by Anton on 30.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class DostupnoTextField: UITextField {
    
    enum LeftViewType {
        case search
        case whiteSpace
    }
    
    enum RightViewType {
        case visible
        case disclosure
        case clear
    }
    
    var leftViewType: LeftViewType? = .none {
        didSet {
            setLeftViewType()
        }
    }
    
    var rightViewType: RightViewType? = .none {
        didSet {
            setRightViewType()
        }
    }
    
    var didBeginEditing: DostupnoTextFieldCallback?
    var textDidChange: DostupnoTextFieldCallback?
    var didEndEditing: DostupnoTextFieldCallback?
    var didEndOnReturn: DostupnoTextFieldCallback?
    
    typealias DostupnoTextFieldCallback = ((String?) -> Void)
    
    private var leftViewDefaultWidth: CGFloat = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupAppearance()
        delegate = self
        if #available(iOS 13.0, *) {
            // in ios 13 available new textfield delegate textFieldDidChangeSelection
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: UITextField.textDidChangeNotification, object: self)
        }
    }
    
    // MARK: - Appearance
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = CGSize(width: leftViewDefaultWidth, height: bounds.height)
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = CGSize(width: 50, height: bounds.height)
        return CGRect(x: bounds.width - size.width, y: 0, width: size.width, height: size.height)
    }
    
    private func setupAppearance() {
        let defaultColor: UIColor = R.color.warmGrey() ?? .lightGray
        roundView(radius: 9, color: R.color.ickyGreen(), borderWidth: 1)
        textColor = defaultColor
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [.foregroundColor: defaultColor])
        tintColor = defaultColor
        font = .p1LeftRegular
    }
    
    // MARK: - RightView
    
    private func setLeftViewType() {
        switch leftViewType {
        case .search:
            setLeftView(icon: R.image.invisible())
        case .whiteSpace:
            setLeftView(icon: nil)
        case .none:
            break
        }
    }
    
    private func setRightViewType() {
        switch rightViewType {
        case .visible:
            setRightView(iconNormal: R.image.hide(), iconSelected: R.image.show(), action: #selector(visibleAction))
        case .disclosure:
            setRightView(iconNormal: R.image.disclosureGreen(), action: #selector(disclosureAction))
        case .clear:
            setClearButton()
        case .none:
            break
        }
    }
    
    private func setLeftView(icon: UIImage?) {
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .center
        
        leftView = imageView
        leftViewMode = .always
    }
    
    private func setRightView(iconNormal: UIImage?,
                              iconSelected: UIImage? = nil,
                              action: Selector,
                              rightViewMode: UITextField.ViewMode = .always) {
        let button = UIButton()
        button.setImage(iconNormal, for: .normal)
        button.setImage(iconSelected ?? iconNormal, for: .selected)
        button.addTarget(self, action: action, for: .touchUpInside)
        self.rightViewMode = rightViewMode
        rightView = button
    }
    
    private func setClearButton() {
        clearButtonMode = .always
    }
    
    // MARK: - Actions
    
    @objc private func visibleAction(sender: UIButton) {
        sender.isSelected.toggle()
        isSecureTextEntry.toggle()
    }
    
    @objc private func disclosureAction(sender: UIButton) {
        
    }
    
}

extension DostupnoTextField: UITextFieldDelegate {

    @objc private func updateText(notification: NSNotification) {
        if let textField = notification.object as? DostupnoTextField {
            textDidChange?(textField.text)
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        textDidChange?(textField.text)
    }    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didEndOnReturn?(textField.text)
        resignFirstResponder()
        return false
    }
}
