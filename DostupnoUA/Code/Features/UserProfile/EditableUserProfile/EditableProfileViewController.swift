//
//  EditableProfileViewController.swift
//  DostupnoUA
//
//  Created by admin on 27.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import SwiftMessages

class EditableProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: EditableProfilePresenterProtocol?
    let tableHeaderView = EditProfileTableViewHeader(frame: CGRect(withHeight: 150))
    let tableFooterView = ChangePasswordView(frame: .layoutDefaultValue)
//    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.viewDidLoad()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableFooterView.updateHeightConstraint()
//    }
    
    func setupViews() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        navigationItem.title = R.string.localizable.editProfileNavigationTitle.localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.checked(), style: .plain, target: self, action: #selector(saveProfileTapped))
        set(isProfileChanged: false)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = tableFooterView
        tableView.tableHeaderView = tableHeaderView
        tableView.register(EditProfileCell.self)
        tableView.register(EditProfileDisclosureCell.self)

        tableView.register(GenericTitleSectionHeaderView.self)
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 20
        
        tableHeaderView.didTapEditButton = { [weak self] in
            self?.presenter?.editPhoto()
        }
        tableFooterView.onDidChange = { [weak self] old, new in
            self?.presenter?.changePassword(old: old, new: new)
        }
    }
    
    func reloadTableView() {
        tableFooterView.updateHeightConstraint()
        tableView.reloadData()
    }
    
    @objc func saveProfileTapped() {
        presenter?.saveProfileTapped()
    }
    
    @objc func backTapped() {
        presenter?.moveBack()
    }
}

extension EditableProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let cellViewModel = presenter?.cellViewModel(at: indexPath)
        cell = cellViewModel?.isDisclosureType == true ? tableView.dequeueCell(EditProfileDisclosureCell.self, for: indexPath) : tableView.dequeueCell(EditProfileCell.self, for: indexPath)
        if let cell = cell as? EditProfileDisclosureCell {
            cell.set(model: cellViewModel)
            cell.onActionTap = { [weak self] in
                self?.presenter?.selectCity()
            }
        } else if let cell = cell as? EditProfileCell {
            cell.set(model: cellViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: GenericTitleSectionHeaderView.reuseKey) as? GenericTitleSectionHeaderView {
            headerView.viewModel = presenter?.titleSectionHeaderViewModel(in: section)
            headerView.set(backgroundColor: tableView.backgroundColor)
            return headerView
        }
        return UIView()
    }

}

extension EditableProfileViewController: EditableProfileViewProtocol {
    
    func editPhoto() {
        let imagePicker = ImagePicker(presentationController: self)
        imagePicker.present(from: self.view, type: .singlePickerWithRemoveButton)
        imagePicker.didSelectImage = { [weak self] image in
            self?.presenter?.setNewImage(image: image)
        }
        imagePicker.didRemoveImage = { [weak self] in
            self?.presenter?.removeImage()
        }
    }
    
    func set(newImage: UIImage?) {
        tableHeaderView.update(image: newImage)
    }
    
    func removeImage() {
        tableHeaderView.removeImage()
    }
    
    func set(headerViewModel: ProfileHeaderViewModel) { }
    
    func set(isProfileChanged: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isProfileChanged
    }
    
    func set(imageUrl: String?) {
        tableHeaderView.set(imageUrl: imageUrl)
    }
}

extension EditableProfileViewController: LoadingViewProtocol {
    
    func startLoading() {
        ProgressView.show(in: view)
    }
    
    func stopLoading(error: Error? = nil) {
        ProgressView.hide(for: view)
        guard let error = error else { return }
        showError(error)
    }
    
    func showError(_ error: Error) {
        SwiftMessages.show(warning: presenter?.errorTitle(from: error))
    }
}

extension EditableProfileViewController {
    
    static func make(with presenter: EditableProfilePresenterProtocol) -> EditableProfileViewController? {
        let viewController = R.storyboard.editableProfile.editableProfileViewController()
        viewController?.presenter = presenter
        presenter.managedView = viewController
        return viewController
    }
}
