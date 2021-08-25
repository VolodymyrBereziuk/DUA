//
//  LocationListViewController.swift
//  DostupnoUA
//
//  Created by Anton on 12.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import KafkaRefresh
import SwiftMessages

class LocationListViewController: UIViewController, LocationListViewProtocol {
    
    var presenter: LocationListPresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchBarContainer = SearchBarPlacesContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    func configureView() {
        configureTableView()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        if presenter?.isFavouriteAppearance == true {
            navigationItem.title = R.string.localizable.profileFavouriteLocationsTitle.localized()
        } else {
            configureSearchBar()
            navigationItem.hidesBackButton = true
        }
    }
    
    func configureTableView() {
        tableView.register(LocationListCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 500
        addBottomRefresControl()
    }
    
    func addBottomRefresControl() {
        let refreshHandler = { [weak self] in
            if self?.presenter?.isFavouriteAppearance == true {
                self?.getFavouriteLocationsContent()
            } else {
                let text = self?.searchBarContainer.searchText
                self?.presenter?.getLocations(by: text, completionHandler: { })
            }

        }
        tableView.bindFootRefreshHandler(refreshHandler, themeColor: (R.color.ickyGreen() ?? .green), refreshStyle: .native)
        tableView.footRefreshControl.autoRefreshOnFoot = true
    }
    
    func configureSearchBar() {
        searchBarContainer.bind(to: view, navigationItem: navigationItem)
        searchBarContainer.onPlaceDidSelect = { [weak self] location in
            self?.presenter?.showLocationDetails(location: location)
        }
        searchBarContainer.onShowAllPlacesDidTap = { [weak self] searchText, locationsResponse in
            self?.addBottomRefresControl()
            self?.tableView.contentOffset = .zero
            self?.presenter?.showLocationList(searchText: searchText, locationsReponse: locationsResponse)
            self?.setSearchBar(text: searchText)
        }
    }
    
    func setSearchBar(text: String?) {
        searchBarContainer.setSearchBar(text: text)
    }
    
    // MARK: - Favourite List Data
    
    func getFavouriteLocationsContent() {
        if presenter?.numberOfRows == 0 {
            ProgressView.show(in: view)
        }
        presenter?.getFavouriteLocations(completion: { [weak self] result in
            ProgressView.hide(for: self?.view)
            if case .failure(let error) = result {
                let errorText = self?.presenter?.errorTitle(for: error)
                SwiftMessages.show(warning: errorText)
            }
        })

    }
    
    // MARK: - LocationListViewProtocol
    
    func reloadTableView() {
        tableView.reloadData()
        if tableView.footRefreshControl != nil {
            tableView.footRefreshControl.endRefreshing()
        }
        if presenter?.allLocationsAlreadyLoaded() == true {
            self.tableView.footRefreshControl = nil
        }
    }
    
    // MARK: - Actions
    
    @objc func backTapped() {
        presenter?.backTapped()
    }
    
    private func tapOnFavourites(at indexPath: IndexPath?) {
        ProgressView.show(in: view)
        presenter?.changeLocationStatus(at: indexPath, completion: { [weak self] result in
            ProgressView.hide(for: self?.view)
            switch result {
            case .success:
                self?.reloadTableView()
            case .failure(let error):
                let errorText = self?.presenter?.errorTitle(for: error)
                SwiftMessages.show(warning: errorText)
            }
        })
    }
}

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueCell(LocationListCell.self, for: indexPath)
        if let cell = cell as? LocationListCell {
            let location = presenter?.location(at: indexPath)
            let locationTypeTitle = presenter?.locationTypeTitle(at: indexPath)
            let isFavourite = presenter?.isFavouriteLocation(location: location)
            cell.setupCell(model: location, typeTitle: locationTypeTitle, indexPath: indexPath, isFavourite: isFavourite)
            
            cell.didTapLikeButton = { [weak self] indexPath in
                self?.tapOnFavourites(at: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectLocation(at: indexPath)
    }

}

extension LocationListViewController {
    
    static func make(with presenter: LocationListPresenter?) -> LocationListViewController? {
        let viewController = R.storyboard.locationList.locationListViewController()
        presenter?.managedView = viewController
        viewController?.presenter = presenter
        return viewController
    }
}
