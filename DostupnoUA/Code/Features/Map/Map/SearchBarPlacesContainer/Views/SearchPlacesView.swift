//
//  SearchPlacesView.swift
//  DostupnoUA
//
//  Created by admin on 03.12.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import UIKit

class SearchPlacesView: UIView {
    
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var showAllButton: UIButton!
    
    let placesPlaceholderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = R.color.warmGrey()
        label.font = .h1CenteredBold
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    var onShowAllPlacesDidTap: (() -> Void)?
    var onPlaceDidSelect: ((Int?) -> Void)?
    
    private var places = [SearchBarPlace]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        xibSetup()
        
        configurePlaceholer()
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.register(SearchPlacesCell.self)
        placesTableView.tableFooterView = UIView(frame: .zero)
        placesTableView.rowHeight = UITableView.automaticDimension
        placesTableView.estimatedRowHeight = 44.0

        showAllButton.isHidden = true
        showAllButton.titleLabel?.font = UIFont.h2LeftBold
        showAllButton.setTitleColor(.white, for: .normal)
        showAllButton.backgroundColor = R.color.ickyGreen()
        showAllButton.addRoundShadow(radius: 30)
    }
    
    func configurePlaceholer() {
        placesPlaceholderLabel.text = R.string.localizable.searchPlaceholderText.localized()
        addSubview(placesPlaceholderLabel, edgeInsets: .zero)
    }
    
    @IBAction func showAllButtonTapped(_ sender: Any) {
        onShowAllPlacesDidTap?()
    }
    
    func setShowAllButtonTitle(placesCount: Int?) {
        guard let placesCount = placesCount, placesCount > 0 else {
            showAllButton.isHidden = true
            placesPlaceholderLabel.isHidden = false
            return
        }
        showAllButton.isHidden = false
        placesPlaceholderLabel.isHidden = true
        var title = R.string.localizable.mapSearchShowAllResults.localized()
        title = title.replacingOccurrences(of: LocalisationConstants.value, with: String(placesCount))
        showAllButton.setTitle(title, for: .normal)
    }
}

extension SearchPlacesView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(SearchPlacesCell.self, for: indexPath)
        let place = places[safe: indexPath.row]
        if let cell = cell as? SearchPlacesCell {
            cell.set(name: place?.name)
            cell.set(imageColor: place?.gradeColor)
            return cell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[safe: indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        onPlaceDidSelect?(place?.id)
    }
}

extension SearchPlacesView: SearchPlacesViewProtocol {
    
    func updateContentLanguage() {
        placesPlaceholderLabel.text = R.string.localizable.searchPlaceholderText.localized()
    }
    
    func cleanPlacesView() {
        reloadPlacesView(with: [])
        setTotalResults(value: nil)
        placesPlaceholderLabel.isHidden = true
    }
    
    func setTotalResults(value: Int?) {
        setShowAllButtonTitle(placesCount: value)
    }
    
    func setSearchView(isHidden: Bool) {
        self.isHidden = isHidden
        placesPlaceholderLabel.isHidden = true
    }
    
    func reloadPlacesView(with places: [SearchBarPlace]) {
        self.places = places
        placesTableView.reloadData()
    }
    
}

struct SearchBarPlace {
    let id: Int
    let name: String?
    let gradeColor: UIColor?
}
