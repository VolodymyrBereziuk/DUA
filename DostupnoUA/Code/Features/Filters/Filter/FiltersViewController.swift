//
//  FiltersViewController.swift
//  DostupnoUA
//
//  Created by admin on 07.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import ActionSheetPicker_3_0
import UIKit

class FiltersViewController: UIViewController, FiltersViewProtocol {
    
    var presenter: FiltersPresenterProtocol?
    
    @IBOutlet weak var showResultsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let filterTitleView = FilterTitleView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.updateContent()
    }
    
    func configureViews() {
        configureTableView()
        
        filterTitleView.set(subtitle: R.string.localizable.filterSelectionSubtitle.localized())
        
        let backButton = UIBarButtonItem(backTarget: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = backButton
        
        showResultsButton.set(style: .green30)
        showResultsButton.setTitle(R.string.localizable.filterShowResultsTitle.localized(), for: .normal)
    }
    
    func configureTableView() {
        tableView.register(FilterCell.self)
        tableView.register(FilterIncludedPickerCell.self)
        tableView.setSelfSized(tableHeaderView: filterTitleView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func set(title: String?) {
        filterTitleView.set(title: title)
        navigationItem.title = title
    }
    func set(titleImageName: String?) {
        let image = UIImage(named: (titleImageName ?? ""))
        filterTitleView.set(titleImage: image)
    }
    
    func reloadFiltersTableView() {
        tableView.reloadData()
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchResultsTapped(_ sender: Any) {
        presenter?.didSearchResults()
    }
    
    func showPicker(titles: [String], selectedItem: Int, onDidSelect: @escaping ((Int?) -> Void)) {
        let picker = ActionSheetStringPicker(title: "", rows: titles, initialSelection: selectedItem, doneBlock: { _, value, _ in
            onDidSelect(value)
            return
        }, cancel: { _ in
            onDidSelect(nil)
            return
        }, origin: view)
        picker?.toolbarButtonsColor = .black
        picker?.show()
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = presenter?.filter(at: indexPath)
        if filter?.selectionFilterType == .includedPicker {
            let cell = tableView.dequeueCell(FilterIncludedPickerCell.self, for: indexPath)
            if let cell = cell as? FilterIncludedPickerCell {
                cell.set(name: filter?.title)
                cell.set(subtitle: filter?.selectedPickerFilterTitle)
            }
            return cell
        }
        
        let cell = tableView.dequeueCell(FilterCell.self, for: indexPath)
        if let cell = cell as? FilterCell {
            cell.indexPath = indexPath
            cell.model = presenter?.cellModel(at: indexPath)
            cell.didTapLeftButton = { [weak self] indexPath in
                self?.presenter?.didTapSelectAll(at: indexPath)
            }
            cell.didTapRightButton = { [weak self] indexPath in
                self?.presenter?.didSelectFilter(at: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didTapFilterCell(at: indexPath)
    }
}

extension FiltersViewController {
    
    static func make(with presenter: FiltersPresenterProtocol?) -> FiltersViewController? {
        let viewController = R.storyboard.filters.filtersViewController()
        viewController?.presenter = presenter
        presenter?.managedView = viewController
        return viewController
    }
}
