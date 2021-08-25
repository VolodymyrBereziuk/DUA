//
//  ImagePicker.swift
//  DostupnoUA
//
//  Created by Anton on 23.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class ImagePicker: NSObject {
    
    enum ImagePickerType {
        case singlePicker
        case multiplePicker(count: Int)
        case singlePickerWithRemoveButton
    }
    
    private let pickerController = UIImagePickerController()
    private let multiplePickerController = OpalImagePickerController()
    private weak var presentationController: UIViewController?
    private var alertController: UIAlertController?
    private var multiplePickerMaxCount: Int = 1
    
    var didSelectImage: ((UIImage?) -> Void)?
    var didSelectImages: (([UIImage]) -> Void)?
    var didRemoveImage: (() -> Void)?
    
    init(presentationController: UIViewController) {
        super.init()
        self.presentationController = presentationController
        pickerController.delegate = self
        pickerController.allowsEditing = true
        setupMultipleImagePicker()
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        
        let action = UIAlertAction(title: title, style: .default) { _ in
            self.pickerController.sourceType = type
            self.pickerController.allowsEditing = type == .camera ? false : true
            self.pickerController.modalPresentationStyle = .fullScreen
            self.presentationController?.present(self.pickerController, animated: true)
        }
        return action
    }
    
    private func actionForMultiplePicker(title: String) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { _ in
            self.showMultiplePicker()
        }
        return action
    }
    
    func present(from sourceView: UIView, type: ImagePickerType? = .singlePicker) {
        
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        guard let alertController = alertController else { return }
        if let action = self.action(for: .camera, title: R.string.localizable.imagePickerTakePhoto.localized()) {
            alertController.addAction(action)
        }
        let singleSelectAction = action(for: .photoLibrary, title: R.string.localizable.imagePickerSelectPhoto.localized())
        let multipleSelectAction = actionForMultiplePicker(title: R.string.localizable.imagePickerSelectPhoto.localized())
        let deletePhotoAction = UIAlertAction(title: R.string.localizable.imagePickerDeletePhoto.localized(), style: .destructive, handler: { [weak self] _ in
            self?.didRemoveImage?()
        })
        switch type {
        case .singlePicker:
            if let action = singleSelectAction {
                alertController.addAction(action)
            }
        case .multiplePicker(let maxCount):
            multiplePickerMaxCount = maxCount
            alertController.addAction(multipleSelectAction)
        case .singlePickerWithRemoveButton:
            if let action = singleSelectAction {
                alertController.addAction(action)
            }
            alertController.addAction(deletePhotoAction)
        case .none:
            break
        }
        
        alertController.addAction(UIAlertAction(title: R.string.localizable.genericCancel.localized(), style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        didSelectImage?(image)
        controller.dismiss(animated: true, completion: nil)
        
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: OpalImagePickerControllerDelegate {
    
    private func showMultiplePicker() {
        multiplePickerController.maximumSelectionsAllowed = multiplePickerMaxCount
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = NSLocalizedString("You can add only \(multiplePickerMaxCount) images", comment: "")
        multiplePickerController.configuration = configuration
        presentationController?.present(multiplePickerController, animated: true, completion: nil)
    }
    
    private func setupMultipleImagePicker() {
        multiplePickerController.imagePickerDelegate = self
        multiplePickerController.modalPresentationStyle = .fullScreen
        multiplePickerController.selectionImageTintColor = R.color.ickyGreen()
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        let requestImageOption = PHImageRequestOptions()
        requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestImageOption.isSynchronous = true
        var images = [UIImage]()
        
        let manager = PHImageManager.default()
        assets.forEach { asset in
            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestImageOption) { (image: UIImage?, _) in
                if let image = image {
                    images.append(image)
                }
            }
        }
        didSelectImages?(images)
        picker.dismiss(animated: true, completion: nil)
    }
    
}
