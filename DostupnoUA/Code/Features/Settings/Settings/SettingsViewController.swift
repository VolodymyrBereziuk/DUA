//
//  SettingsViewController.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: SettingsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        presenter?.viewWillAppear()
        tableView.reloadData()
    }
    
    func configureViews() {
        tableView.register(SettingsCell.self)
        tableView.contentInset = .init(left: 0, right: 0, top: 15, bottom: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationBar() {
        navigationItem.title = R.string.localizable.profileSettingsTitle.localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
    }
    
    @objc func backTapped() {
        presenter?.backTapped()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SettingsCell.self, for: indexPath)
        let viewModel = presenter?.cellData(at: indexPath.row)
        if let cell = cell as? SettingsCell {
            cell.set(title: viewModel?.title)
            cell.set(image: viewModel?.icon)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectItem(at: indexPath.row)
    }
}

extension SettingsViewController {
    
    static func make(presenter: SettingsPresenterProtocol) -> SettingsViewController? {
        let viewController = R.storyboard.settings.settingsViewController()
        viewController?.presenter = presenter
        presenter.managedView = viewController
        return viewController
    }
}
