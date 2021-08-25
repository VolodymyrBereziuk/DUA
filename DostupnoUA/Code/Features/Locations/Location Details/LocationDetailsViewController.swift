//
//  LocationDetailsViewController.swift
//  DostupnoUA
//
//  Created by Anton on 14.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import SwiftMessages

class LocationDetailsViewController: UIViewController, LocationDetailsViewProtocol {
    
    var presenter: LocationDetailsPresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableHeaderView = LocationDetailsHeaderView(frame: .zero)
    let tableFooterView = LocationDetailsFooterView(frame: CGRect(withHeight: 90))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        configureView()
    }
    
    // MARK: - Appearance
    
    func configureView() {
        configureTableView()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        //TODO: add in the next version
        //let editButton = UIBarButtonItem(image: R.image.edit(), style: .plain, target: self, action: #selector(editTapped))
        //navigationItem.rightBarButtonItem = editButton
    }
    
    func configureTableView() {
        tableView.register(LocationDetailsNoFilterCell.self)
        tableView.register(LocationDetailsOneFilterCell.self)
        tableView.register(LocationDetailsThreeFilterCell.self)
        
        tableView.tableFooterView = tableFooterView
        tableView.setSelfSized(tableHeaderView: tableHeaderView)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableFooterView.set(isCommentsAvailable: presenter?.isCommentsAvailable ?? false)
        tableFooterView.didTapRouteButton = { [weak self] in self?.routeActionSheet() }
        tableFooterView.didTapCommentButton = { [weak self] in self?.presenter?.toComments() }
        
        tableHeaderView.didTapLikeButton = { [weak self] in
            self?.tapOnFavourites()
        }
    }
    
    private func routeActionSheet() {
        showActionSheetView(title: R.string.localizable.locationsDetailsRouteActionTitle.localized(), firstActionTitle: R.string.localizable.locationsDetailsMakeRouteApple.localized(), secondActionTitle: R.string.localizable.locationsDetailsMakeRouteGoogle.localized(), firstAction: { [weak self] _ in
            self?.presenter?.makeRoute(type: .apple)
            }, secondAction: { [weak self] _ in
                self?.presenter?.makeRoute(type: .google)
        })
    }
    
    // MARK: - Actions
    
    @objc func backTapped() {
        presenter?.backTapped()
    }
    
    @objc func editTapped() {
        presenter?.editTapped()
    }
    
    private func tapOnFavourites() {
        ProgressView.show(in: view)
        presenter?.changeLocationStatus(completion: { [weak self] result in
            ProgressView.hide(for: self?.view)
            switch result {
            case .success:
                self?.reloadViewContent()
            case .failure(let error):
                let errorText = self?.presenter?.errorTitle(for: error)
                SwiftMessages.show(warning: errorText)
            }
        })
    }
    // MARK: - LocationDetailsViewProtocol
    
    func reloadViewContent() {
        navigationItem.title = presenter?.navigationTitle
        tableHeaderView.content = presenter?.headerContent
        tableView.reloadData()
    }
}

extension LocationDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter?.model(at: indexPath)
        if let model = model as? NoFilterCellModel, let cell = tableView.dequeueCell(LocationDetailsNoFilterCell.self, for: indexPath) as? LocationDetailsNoFilterCell {
            cell.setupCell(model: model)
            cell.didTapMapButton = { [weak self] in
                self?.presenter?.toLocationMapPosition()
            }
            return cell
        } else if let model = model as? OneFilterCellModel, let cell = tableView.dequeueCell(LocationDetailsOneFilterCell.self, for: indexPath) as? LocationDetailsOneFilterCell {
            cell.setupCell(model: model)
            return cell
        } else if let model = model as? ThreeFilterCellModel, let cell = tableView.dequeueCell(LocationDetailsThreeFilterCell.self, for: indexPath) as? LocationDetailsThreeFilterCell {
            cell.setupCell(model: model)
            return cell
        }
        return UITableViewCell()
    }
    
}

extension LocationDetailsViewController {
    
    static func make(with presenter: LocationDetailsPresenter?) -> LocationDetailsViewController? {
        let viewController = R.storyboard.locationDetails.locationDetailsViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}
