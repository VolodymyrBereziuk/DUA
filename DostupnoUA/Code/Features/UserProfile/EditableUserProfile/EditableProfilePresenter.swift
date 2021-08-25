//
//  EditableProfilePresenter.swift
//  DostupnoUA
//
//  Created by admin on 27.02.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol EditableProfileNavigation {
    var backToProfile: (() -> Void)? { get set }
    var reloadProfile: (() -> Void)? { get set }
    var toCitySelection: ((String?) -> Void)? { get set }
}

protocol EditableProfileViewProtocol: AnyObject {
    var presenter: EditableProfilePresenterProtocol? { get set }
    
    func set(isProfileChanged: Bool)
    func set(imageUrl: String?)
    func set(newImage: UIImage?)
    func removeImage()
    func reloadTableView()
    func editPhoto()
}

protocol EditableProfilePresenterProtocol: AnyObject {
    var managedView: EditableProfileViewProtocol? { get set }
    var numberOfSections: Int { get }
    
    func viewDidLoad()
    
    func numberOfRows(in section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> EditProfileCellViewModel?
    func titleSectionHeaderViewModel(in section: Int) -> GenericTitleSectionHeaderViewModel?
    
    func saveProfileTapped()
    func changePassword(old: String, new: String)
    func editPhoto()
    func setNewImage(image: UIImage?)
    func removeImage()
    func selectCity()
    func updateCity(id: String, name: String?)
    func moveBack()
    func errorTitle(from error: Error) -> String
}

class EditableProfilePresenter: EditableProfilePresenterProtocol, LoadingPresenterProtocol {
    
    weak var managedView: EditableProfileViewProtocol?
    
    var managedLoadingView: LoadingViewProtocol? {
        return managedView as? LoadingViewProtocol
    }
    
    let profile: UserProfile
    private var userEditProfile: UpdateProfileModel?
    private let navigation: EditableProfileNavigation
    private var cellViewModels = [[EditProfileCellViewModel]]()
    
    init(navigation: EditableProfileNavigation, profile: UserProfile) {
        self.navigation = navigation
        self.profile = profile
        var cityTitle: String?
        
        StorageManager.shared.getFilters(onSuccess: { filtersList in
            let cityFilters = filtersList.cities?.filters ?? []
            cityTitle = cityFilters.first(where: { $0.id == profile.city })?.title
        })
        userEditProfile = UpdateProfileModel(firstName: profile.firstName, lastName: profile.lastName, email: profile.email, phone: profile.tel, city: cityTitle, cityID: profile.city, password: nil, oldPassword: nil)
    }
    
    func viewDidLoad() {
        setTableViewHeaderContent()
        createCellsContent()
    }
    
    func setTableViewHeaderContent() {
        let imageUrl = profile.photo
        managedView?.set(imageUrl: imageUrl)
    }
    
    func titleSectionHeaderViewModel(in section: Int) -> GenericTitleSectionHeaderViewModel? {
        return GenericTitleSectionHeaderViewModel(title: R.string.localizable.editProfileInfoHeader.localized(), titleColor: R.color.warmGrey(), isLineHidden: true)
    }
    
    private func createCellsContent() {
        let firstSectionContent = [
            EditProfileCellViewModel(text: userEditProfile?.firstName, placeholderText: R.string.localizable.editProfileInfoNamePlaceholder.localized(), labelsType: .noValidate, rightViewType: .clear, keyboardType: .default, valueUpdate: { [weak self] value in
                self?.userEditProfile?.firstName = value
                self?.managedView?.set(isProfileChanged: true)
            }),
            EditProfileCellViewModel(text: userEditProfile?.lastName, placeholderText: R.string.localizable.editProfileInfoSurnamePlaceholder.localized(), labelsType: .noValidate, rightViewType: .clear, keyboardType: .default, valueUpdate: { [weak self] value in
                self?.userEditProfile?.lastName = value
                self?.managedView?.set(isProfileChanged: true)
            }),
// email editing is disabled, because current implementation is not secure
//            EditProfileCellViewModel(text: userEditProfile?.email, placeholderText: R.string.localizable.editProfileInfoEmailPlaceholder.localized(), labelsType: .formatLabel(mask: .email), rightViewType: .none, keyboardType: .emailAddress, valueUpdate: { [weak self] value in
//                self?.userEditProfile?.email = value
//                self?.managedView?.set(isProfileChanged: true)
//            }),
            EditProfileCellViewModel(text: userEditProfile?.phone, placeholderText: R.string.localizable.editProfileInfoPhonePlaceholder.localized(), labelsType: .formatLabel(mask: .phone), rightViewType: .none, keyboardType: .phonePad, valueUpdate: { [weak self] value in
                self?.userEditProfile?.phone = value
                self?.managedView?.set(isProfileChanged: true)
            }),
            EditProfileCellViewModel(text: userEditProfile?.city, placeholderText: R.string.localizable.editProfileInfoCityPlaceholder.localized(), labelsType: .noValidate, rightViewType: .disclosure, isDisclosureType: true, valueUpdate: nil)
        ]
        cellViewModels = [firstSectionContent]
        managedView?.reloadTableView()
    }
    
    var numberOfSections: Int {
        return cellViewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return cellViewModels[safe: section]?.count ?? 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> EditProfileCellViewModel? {
        return cellViewModels[safe: indexPath.section]?[safe: indexPath.row]
    }
    
    func saveProfileTapped() {
        updateUserProfile()
    }
    
    func changePassword(old: String, new: String) {
        updatePassword(old: old, new: new)
    }
    
    func editPhoto() {
        managedView?.editPhoto()
    }
    
    func setNewImage(image: UIImage?) {
        userEditProfile?.photo = image
        userEditProfile?.photoAction = .upload
        managedView?.set(isProfileChanged: true)
        managedView?.set(newImage: image)
    }
    
    func removeImage() {
        userEditProfile?.photo = nil
        userEditProfile?.photoAction = .delete
        managedView?.set(isProfileChanged: true)
        managedView?.removeImage()
    }
    
    func updateCity(id: String, name: String?) {
        userEditProfile?.city = name
        userEditProfile?.cityID = id
        managedView?.set(isProfileChanged: true)
        createCellsContent()
    }
    
    // MARK: - Navigation
    
    func moveBack() {
        navigation.backToProfile?()
    }
    
    func reloadProfile() {
        navigation.reloadProfile?()
    }
    
    func selectCity() {
        navigation.toCitySelection?(userEditProfile?.city)
    }
    
    // MARK: - API
    
    private func updateUserProfile() {
        managedLoadingView?.startLoading()
        let lang = LocalisationManager.shared.currentLanguage.rawValue
        let connection = UpdateProfileConnection(parametersModel: userEditProfile, language: lang)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] _ in
            self?.updateProfileData()
            }, failureHandler: { [weak self] error in
                self?.managedLoadingView?.stopLoading(error: error)
                print(error.localizedDescription)
        })
    }
    
    private func updatePassword(old: String, new: String) {
        managedLoadingView?.startLoading()
        let updatePasswordModel = UpdateProfileModel(password: new, oldPassword: old)
        let lang = LocalisationManager.shared.currentLanguage.rawValue
        let connection = UpdateProfileConnection(parametersModel: updatePasswordModel, language: lang)
        APIClient.shared.start(connection: connection, successHandler: { [weak self] _ in
            self?.updateProfileData()
            }, failureHandler: { [weak self] error in
                self?.managedLoadingView?.stopLoading(error: error)
                print(error.localizedDescription)
        })
    }
    
    private func updateProfileData() {
        StorageManager.shared.getUserProfile(forceDownload: true, onSuccess: { [weak self] _ in
            self?.managedLoadingView?.stopLoading()
            self?.reloadProfile()
            }, onFailure: { [weak self] error in
                self?.managedLoadingView?.stopLoading(error: error)
                print(error.localizedDescription)
        })
    }
    
    // MARK: - Error
    
    func errorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case UpdateProfileConnectionError.notLoggedInUser:
            message = R.string.localizable.errorUserProfileNotLoggedInUser.localized()
        case UpdateProfileConnectionError.forbidden:
            message = R.string.localizable.errorUserProfileForbidden.localized()
        case UpdateProfileConnectionError.inputData:
            message = R.string.localizable.errorUpdateUserProfileInputData.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
}
