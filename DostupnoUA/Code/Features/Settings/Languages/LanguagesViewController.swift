//
//  LanguagesViewController.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter: LanguagesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupNavigationBar()
    }
    
    func configureViews() {
        tableView.register(LanguageCell.self)
        tableView.contentInset = .init(left: 0, right: 0, top: 9, bottom: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationBar() {
        updateNavigationBarTitle()
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
    }
    
    func updateNavigationBarTitle() {
        navigationItem.title = R.string.localizable.languageTitle.localized()
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LanguagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(LanguageCell.self, for: indexPath)
        let viewModel = presenter?.cellData(at: indexPath.row)
        if let cell = cell as? LanguageCell {
            cell.set(title: viewModel?.title)
            cell.set(isSelected: viewModel?.isSelected)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectItem(at: indexPath.row)
        updateNavigationBarTitle()
        tableView.reloadData()
    }
    
}

extension LanguagesViewController {
    
    static func make(presenter: LanguagesPresenterProtocol) -> LanguagesViewController? {
        let viewController = R.storyboard.languages.languagesViewController()
        viewController?.presenter = presenter
        return viewController
    }
}
