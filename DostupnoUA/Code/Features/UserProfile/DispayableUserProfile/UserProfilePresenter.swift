//
//  UserProfileViewModel.swift
//  DostupnoUA
//
//  Created by admin on 14.10.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

protocol UserProfileNavigation {
    var toEditProfile: ((UserProfile) -> Void)? { get set }
    var toAuthorizationFlow: (() -> Void)? { get set }
    var toSettings: (() -> Void)? { get set }
    var toFavouriteLocations: (() -> Void)? { get set }
}

protocol UserProfileViewProtocol: AnyObject {
    var presenter: UserProfilePresenterProtocol? { get set }
    
    func set(headerViewModel: ProfileHeaderViewModel)
    func setVolunteerView(isHidden: Bool)
    func showWebView(by urlAddress: String)
}

protocol UserProfilePresenterProtocol {
    var managedView: UserProfileViewProtocol? { get set }
    var numberOfSections: Int { get }
    
    func numberOfRows(in section: Int) -> Int
    func cellViewModel(at indexPath: IndexPath) -> ProfileCellViewModel?
    func didSelectItem(at indexPath: IndexPath)
    func titleSectionHeaderViewModel(in section: Int) -> GenericTitleSectionHeaderViewModel?
    func isHeaderWithTitle(in section: Int) -> Bool
    func getContent(forceDownload: Bool, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void)
    func editProfileTapped()
    func errorTitle(from error: Error) -> String
}

class UserProfilePresenter: UserProfilePresenterProtocol {
    
    weak var managedView: UserProfileViewProtocol?
    var cellViewModels = [[ProfileCellViewModel]]()
    var titleSectionHeaderViewModels = [GenericTitleSectionHeaderViewModel]()
    private let navigation: UserProfileNavigation
    var profile: UserProfile?
    var cityFilters: [Filter] = []
    var downloadGroup = DispatchGroup()
    
    init(navigation: UserProfileNavigation) {
        self.navigation = navigation
    }
    
    func getContent(forceDownload: Bool, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        downloadGroup = DispatchGroup()
        getFilters(forceDownload: forceDownload)
        getUserProfile(forceDownload: forceDownload)
        downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.prepareContent(onSuccess: onSuccess)
        }
    }
    
    func getFilters(forceDownload: Bool) {
        downloadGroup.enter()
        StorageManager.shared.getFilters(onSuccess: { [weak self] filtersList in
            self?.cityFilters = filtersList.cities?.filters ?? []
            self?.downloadGroup.leave()
            }, onFailure: { [weak self] _ in
                self?.downloadGroup.leave()
        })
    }
    
    func getUserProfile(forceDownload: Bool) {
        downloadGroup.enter()
        StorageManager.shared.getUserProfile(forceDownload: forceDownload, onSuccess: { [weak self] profile in
            self?.profile = profile
            self?.downloadGroup.leave()
            }, onFailure: { [weak self] _ in
                self?.downloadGroup.leave()
        })
    }
    
    func prepareContent(onSuccess: @escaping () -> Void) {
        prepareTitleSectionHeaders()
        prepareContent()
        setHeaderContent()
        setFooterContent()
        onSuccess()
    }
    
    func setHeaderContent() {
        let name = [profile?.firstName, profile?.lastName]
            .compactMap({ $0?.isEmptyOrWhitespace == false ? $0 : nil })
            .joined(separator: " ")
        let viewModel = ProfileHeaderViewModel(imageUrlText: profile?.photo, name: name)
        managedView?.set(headerViewModel: viewModel)
    }
    
    func setFooterContent() {
        managedView?.setVolunteerView(isHidden: profile?.isVolunteer == false)
    }
    
    func prepareTitleSectionHeaders() {
        titleSectionHeaderViewModels = [
            GenericTitleSectionHeaderViewModel(title: R.string.localizable.profilePersonalDataTitle.localized(), titleColor: R.color.warmGrey(), isLineHidden: true),
            GenericTitleSectionHeaderViewModel(title: R.string.localizable.profileActionsTitle.localized(), titleColor: R.color.warmGrey(), isLineHidden: false)
        ]
    }
    
    var numberOfSections: Int {
        return cellViewModels.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return cellViewModels[safe: section]?.count ?? 0
    }
    
    func cellViewModel(at indexPath: IndexPath) -> ProfileCellViewModel? {
        return cellViewModels[safe: indexPath.section]?[safe: indexPath.row]
    }
    
    func titleSectionHeaderViewModel(in section: Int) -> GenericTitleSectionHeaderViewModel? {
        return titleSectionHeaderViewModels[safe: section]
    }
    
    func isHeaderWithTitle(in section: Int) -> Bool {
        return section == 0 || section == 1
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let cellViewModel = cellViewModels[safe: indexPath.section]?[safe: indexPath.row]
        cellViewModel?.action?()
    }
    
    func editProfileTapped() {
        if let profile = profile {
            navigation.toEditProfile?(profile)
        }
    }
    
    func showWebView(by urlAddress: String) {
        managedView?.showWebView(by: urlAddress)
    }
    
    private func logout() {
        PersistenceManager.manager.logout()
        StorageManager.shared.clearContent()
        navigation.toAuthorizationFlow?()
    }
    
    func prepareContent() {
        let firstSection = prepareFirstContentSection()
        let secondSection = prepareSecondContentSection()
        
        //        let thirdSection = [ProfileCellViewModel(title: R.string.localizable.profileSettingsTitle.localized(), titleColor: R.color.ickyGreen(), image: R.image.settings())]
        let forthSection = [ProfileCellViewModel(title: R.string.localizable.profileLogoutTitle.localized(),
                                                 titleColor: R.color.ickyGreen(),
                                                 action: logout,
                                                 image: R.image.exit())]
        
        cellViewModels = [firstSection, secondSection, /*thirdSection,*/ forthSection]
    }
    
    func prepareFirstContentSection() -> [ProfileCellViewModel] {
        let emailTitle: String?
        if profile?.email?.isEmptyOrWhitespace == false {
            emailTitle = profile?.email
        } else {
            emailTitle = R.string.localizable.profileAddEmailTitle.localized()
        }
        let phoneTitle: String?
        if profile?.tel?.isEmptyOrWhitespace == false {
            phoneTitle = profile?.tel
        } else {
            phoneTitle = R.string.localizable.profileAddPhoneNumberTitle.localized()
        }
        let cityTitle: String?
        if profile?.city?.isEmptyOrWhitespace == false {
            cityTitle = cityFilters.first(where: { $0.id == profile?.city })?.title
        } else {
            cityTitle = R.string.localizable.profileAddCityTitle.localized()
        }
        let emailViewModel = ProfileCellViewModel(title: emailTitle, titleColor: R.color.warmGrey(), isSelectable: false, image: R.image.mail())
        let phoneViewModel = ProfileCellViewModel(title: phoneTitle, titleColor: R.color.warmGrey(), isSelectable: false, image: R.image.phone())
        let cityViewModel = ProfileCellViewModel(title: cityTitle, titleColor: R.color.warmGrey(), isSelectable: false, image: R.image.location())
        
        return [emailViewModel, phoneViewModel, cityViewModel]
    }
    
    func prepareSecondContentSection() -> [ProfileCellViewModel] {
        let secondSection = [
            ProfileCellViewModel(title: R.string.localizable.profileFavouriteLocationsTitle.localized(),
                                 titleColor: R.color.ickyGreen(),
                                 action: { [weak self] in
                                    self?.navigation.toFavouriteLocations?()
                                 },
                                 image: R.image.likeNotActive()),
            ProfileCellViewModel(title: R.string.localizable.profileSettingsTitle.localized(),
                                 titleColor: R.color.ickyGreen(),
                                 action: { [weak self] in
                                    self?.navigation.toSettings?()
                },
                                 image: R.image.settings()),
            ProfileCellViewModel(title: R.string.localizable.profileArticlesTitle.localized(),
                                 titleColor: R.color.ickyGreen(),
                                 action: { [weak self] in
                                    self?.showWebView(by: R.string.localizable.linkArticlesUrl.localized())
                },
                                 image: R.image.article()),
            ProfileCellViewModel(title: R.string.localizable.genericSupportDostupnoTitle.localized(),
                                 titleColor: R.color.ickyGreen(),
                                 action: { [weak self] in
                                    self?.showWebView(by: R.string.localizable.linkSupportDostupno.localized())
                },
                                 image: R.image.web()),
            ProfileCellViewModel(title: R.string.localizable.genericAboutDostupnoTitle.localized(),
                                 titleColor: R.color.ickyGreen(),
                                 action: { [weak self] in
                                    self?.showWebView(by: R.string.localizable.linkAboutDostupno.localized())
                },
                                 image: R.image.web()),
            ProfileCellViewModel(title: R.string.localizable.profileToDostupnoSiteTitle.localized(),
                                 titleColor: R.color.ickyGreen(),
                                 action: { [weak self] in
                                    self?.showWebView(by: R.string.localizable.linkProfileSite.localized())
                },
                                 image: R.image.web())
        ]
        return secondSection
    }
    
    // MARK: - Error
    
    func errorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case UserProfileConnectionError.notLoggedInUser:
            message = R.string.localizable.errorUserProfileNotLoggedInUser.localized()
        case UserProfileConnectionError.forbidden:
            message = R.string.localizable.errorUserProfileForbidden.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
}
