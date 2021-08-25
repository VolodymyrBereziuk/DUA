//
//  MainFiltersViewController.swift
//  DostupnoUA
//
//  Created by admin on 04.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class MainFiltersViewController: UIViewController, MainFiltersViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    let citySelectionView = CityHeaderView(frame: .zero)
    
    var presenter: MainFiltersPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    func configureViews() {
        configureTableView()
        configureNavigationBar()
        configureSearchBar()
        configureCitySelection()
    }
    
    func configureTableView() {
        tableView.register(MainFilterCell.self)
        tableView.setSelfSized(tableHeaderView: citySelectionView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func configureNavigationBar() {
        navigationItem.title = R.string.localizable.filterTitle.localized()
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        setClearAllButton(isHidden: false)
    }
    
    func setClearAllButton(isHidden: Bool) {
        let clearAllButton = UIBarButtonItem(closeTarget: self, action: #selector(clearFiltersTapped))
        navigationItem.rightBarButtonItem = isHidden ? nil : clearAllButton
    }
    
    func configureSearchBar() {
        searchButton.setEnablingMode(to: false)
        searchButton.titleLabel?.font = UIFont.h2LeftBold
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = R.color.ickyGreen()
        searchButton.addRoundShadow(radius: 30)
        searchButton.setTitle(R.string.localizable.filterShowResultsTitle.localized(), for: .normal)
    }
    
    func configureCitySelection() {
        citySelectionView.didTapCitySelection = { [weak self] in
            self?.presenter?.showCitySelection()
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        presenter?.didSearchResults()
    }
    
    @objc func backTapped() {
        presenter?.backTapped()
    }
    
    @objc func clearFiltersTapped() {
        showClearFiltersAlert()
    }
    
    func reloadFiltersTableView() {
        tableView.reloadData()
        
        let isSearchButtonDisabled = presenter?.numberOfRows == 0
        searchButton.setEnablingMode(to: isSearchButtonDisabled == false)
    }
    
    func set(currentCity: String?) {
        citySelectionView.set(cityName: currentCity)
    }
    
    func showClearFiltersAlert() {
        let title = R.string.localizable.filterMainClearAllAlertTitle.localized()
        let message = R.string.localizable.filterMainClearAllAlertSubtitle.localized()
        let actionTitle = R.string.localizable.filterMainClearAllAlertActionDo.localized()
        let cancelTitle = R.string.localizable.filterMainClearAllAlertActionCancel.localized()
        
        let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
            self?.presenter?.didClearAllFilters()
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .destructive, handler: nil)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension MainFiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = presenter?.cellModel(at: indexPath),
            let cell = tableView.dequeueCell(MainFilterCell.self, for: indexPath) as? MainFilterCell {
            cell.model = model
            cell.didTapButton = { [weak self] in
                self?.presenter?.didSelectCell(at: indexPath, isSelected: (model.isSelected))
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectCell(at: indexPath, isSelected: false)
    }
}

extension MainFiltersViewController {
    
    static func make(with presenter: MainFiltersPresenterProtocol?) -> MainFiltersViewController? {
        let viewController = R.storyboard.mainFilters.mainFiltersViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}
