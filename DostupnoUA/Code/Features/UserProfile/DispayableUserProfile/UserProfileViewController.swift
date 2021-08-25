//
//  ProfileViewController.swift
//  DostupnoUA
//
//  Created by admin on 10/6/19.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import Kingfisher
import SwiftMessages
import UIKit

class UserProfileViewController: UIViewController, UserProfileViewProtocol {
    
    @IBOutlet weak var tabBarView: TabBarView!
    @IBOutlet weak var profileTableView: UITableView!
    
    var presenter: UserProfilePresenterProtocol?
    let tableHeaderView = ProfileHeaderView(frame: CGRect(withHeight: 200))
    let tableFooterView = VolunteerOfferView(frame: .layoutDefaultValue)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileTableView()
        configureTabBarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        getContent()
        tableFooterView.updateContentLanguage()
    }
    
    func configureNavigationBar() {
        navigationItem.title = R.string.localizable.profileDisplayNavigationTitle.localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.edit(), style: .plain, target: self, action: #selector(editProfileTapped))
    }
    
    func configureTabBarView() {
        tabBarView.selectedTabBarItem = .profile
        tabBarView.onScanTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
        tabBarView.onMapTap = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
        }
    }
    
    func configureProfileTableView() {
        profileTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableHeaderView.backgroundColor = R.color.white247()
        
        profileTableView.backgroundColor = R.color.white247()
        profileTableView.register(ProfileCell.self)
        profileTableView.tableHeaderView = tableHeaderView
        
        profileTableView.register(LineTableSectionSeparator.self)
        profileTableView.register(GenericTitleSectionHeaderView.self)
        
        profileTableView.sectionHeaderHeight = UITableView.automaticDimension
        profileTableView.estimatedSectionHeaderHeight = 25
    }
    
    @objc private func refreshData(_ sender: Any) {
        presenter?.getContent(forceDownload: true, onSuccess: { [weak self] in
            self?.profileTableView.reloadData()
            self?.refreshControl.endRefreshing()
            }, onFailure: { [weak self] error in
                self?.refreshControl.endRefreshing()
                self?.showError(error)
        })
    }
    
    func setVolunteerView(isHidden: Bool) {
        profileTableView.tableFooterView = tableFooterView
        tableFooterView.onActionTap = { [weak self] in
            self?.showWebView(by: R.string.localizable.linkProfileVolonteer.localized())
        }
    }
    
    func set(headerViewModel: ProfileHeaderViewModel) {
        tableHeaderView.viewModel = headerViewModel
    }
    
    @objc func editProfileTapped() {
        presenter?.editProfileTapped()
    }
    
    func showError(_ error: Error) {
        SwiftMessages.show(warning: presenter?.errorTitle(from: error))
    }
    
    func getContent() {
        ProgressView.show(in: view)
        presenter?.getContent(forceDownload: false, onSuccess: { [weak self] in
            ProgressView.hide(for: self?.view)
            self?.tableFooterView.updateHeightConstraint()
            self?.profileTableView.reloadData()
            }, onFailure: { [weak self] error in
                ProgressView.hide(for: self?.view)
                self?.showError(error)
        })
    }
    
    func showWebView(by urlAddress: String) {
        let webViewController = WebViewController(urlString: urlAddress)
        navigationController?.show(webViewController, sender: nil)
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView?
        if presenter?.isHeaderWithTitle(in: section) == true {
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: GenericTitleSectionHeaderView.reuseKey)
            if let headerView = headerView as? GenericTitleSectionHeaderView {
                headerView.viewModel = presenter?.titleSectionHeaderViewModel(in: section)
                headerView.set(backgroundColor: tableView.backgroundColor)
            }
        } else {
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: LineTableSectionSeparator.reuseKey)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ProfileCell.self, for: indexPath)
        let cellViewModel = presenter?.cellViewModel(at: indexPath)
        if let cell = cell as? ProfileCell, let cellViewModel = cellViewModel {
            cell.viewModel = cellViewModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellViewModel = presenter?.cellViewModel(at: indexPath), cellViewModel.isSelectable {
            presenter?.didSelectItem(at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserProfileViewController {
    
    static func make(withViewModel viewModel: UserProfilePresenterProtocol) -> UserProfileViewController? {
        let viewController = R.storyboard.userProfile.userProfileViewController()
        viewController?.presenter = viewModel
        return viewController
    }
}
