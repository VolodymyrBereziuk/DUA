//
//  CitySelectionViewController.swift
//  DostupnoUA
//
//  Created by admin on 23.03.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class CitySelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let citySelectionView = CitySelectionView(frame: .zero)
    
    var presenter: CitySelectionPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        configureCitySelectionView()
        presenter?.viewDidLoad()
    }
    
    func configureTableView() {
        tableView.register(SearchPlacesCell.self)
        tableView.setSelfSized(tableHeaderView: citySelectionView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureNavigationBar() {
        navigationItem.title = R.string.localizable.filterCitySearchTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureCitySelectionView() {
        citySelectionView.onCityTextDidChange = { [weak self] cityText in
            self?.presenter?.set(citySearchText: cityText)
        }
        citySelectionView.didBeginEditing = { [weak self] cityText in
            self?.presenter?.set(citySearchText: cityText)
        }
    }
    
    @objc func backTapped() {
        presenter?.backTapped()
    }
    
    func set(currentCity: String?) {
        citySelectionView.set(cityName: currentCity)
    }
    
    func setClearButton(isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem = nil
        } else {
            let clearButton = UIBarButtonItem(closeTarget: self, action: #selector(clearSelectionTapped))
            navigationItem.rightBarButtonItem = clearButton
        }
    }
    
    @objc func clearSelectionTapped() {
        presenter?.didClearSelection()
    }
}

extension CitySelectionViewController: CitySelectionViewProtocol {
    func reloadCityTableView() {
        tableView.reloadData()
    }
}

extension CitySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter?.cellModel(at: indexPath.row)
        if let cell = tableView.dequeueCell(SearchPlacesCell.self, for: indexPath) as? SearchPlacesCell {
            cell.set(name: model?.name)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectCell(at: indexPath.row)
    }
}

extension CitySelectionViewController {
    
    static func make(with presenter: CitySelectionPresenterProtocol?) -> CitySelectionViewController? {
        let viewController = R.storyboard.citySelection.citySelectionViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}
