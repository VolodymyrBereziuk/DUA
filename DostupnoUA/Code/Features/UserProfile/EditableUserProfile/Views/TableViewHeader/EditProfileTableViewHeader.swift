//
//  EditProfileTableViewHeader.swift
//  DostupnoUA
//
//  Created by admin on 28.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Kingfisher
import UIKit

class EditProfileTableViewHeader: UIView {

    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var blackAreaView: UIView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var didTapEditButton: (() -> Void)?
    
    private var imageUrl: String?
    
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
        blackAreaView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        editLabel.textColor = .white
        editLabel.font = .p3LeftBold
        editLabel.text = R.string.localizable.editProfilePhotoEdit.localized()
        photoContainerView.roundView(radius: photoContainerView.frame.width / 2)
        photoImageView.image = R.image.splashScreen()
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        didTapEditButton?()
    }
    
    func set(imageUrl: String?) {
        let url = URL(string: imageUrl ?? "")
        photoImageView.kf.setImage(with: url, placeholder: R.image.avatarEmpty())
    }
    
    func update(image: UIImage?) {
        guard let image = image else { return }
        photoImageView.image = image
    }
    
    func removeImage() {
        photoImageView.image = R.image.avatarEmpty()
    }
}
