//
//  SearchBarPlacesContainer.swift
//  DostupnoUA
//
//  Created by admin on 26.01.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class SearchBarPlacesContainer {
    
    enum SearchState {
        case initial
        case emptyEdit
        case edit
    }
    
    var state: SearchState = .initial {
        didSet {
            switch state {
            case .initial:
                searchBar?.resignFirstResponder()
                searchBar?.setShowsCancelButton(false, animated: true)
                searchBar?.clearSearchBar()
                searchPlacesView?.cleanPlacesView()
                setSearchPlacesView(isHidden: true)
                stopSearchButton?.isHidden = true
            case .emptyEdit:
                searchPlacesPresenter.cleanPlacesView(isTextEmpty: true)
                setSearchPlacesView(isHidden: true)
                if let stopSearchButton = stopSearchButton {
                    stopSearchButton.isHidden = false
                    stopSearchButton.superview?.bringSubviewToFront(stopSearchButton)
                }
            case .edit:
                setSearchPlacesView(isHidden: false)
                stopSearchButton?.isHidden = true
            }
        }
    }
    
    var onPlaceDidSelect: ((Location) -> Void)?
    var onShowAllPlacesDidTap: ((String?, LocationsResponse) -> Void)?
    
    private weak var searchBar: DostupnoSearchBar?
    private weak var searchPlacesView: SearchPlacesViewProtocol?
    private var searchPlacesPresenter: SearchPlacesPresenterProtocol = SearchPlacesPresenter()
    private weak var stopSearchButton: UIButton?
    
    func updateContentLanguage() {
        searchPlacesView?.updateContentLanguage()
        searchBar?.updateContentLanguage()
    }
        
    func bind(to mainView: UIView, navigationItem: UINavigationItem) {
        searchBar = makeSearchBar(owner: navigationItem)
        searchPlacesView = makeSearchPlacesView(owner: mainView)
        stopSearchButton = makeStopSeachButton(owner: mainView)
        searchPlacesPresenter.managedView = searchPlacesView
        configureSearchBar()
        configurePlaceListView()
    }
    
    func setSearchPlacesView(isHidden: Bool) {
        searchPlacesView?.setSearchView(isHidden: isHidden)
    }
    
    func setSearchBar(text: String?) {
        if let text = text {
            searchBar?.text = text
        } else {
            searchBar?.clearSearchBar()
        }
    }
    
    var searchText: String? {
        return searchBar?.text
    }
}

extension SearchBarPlacesContainer {
    
    private func makeSearchBar(owner navigationItem: UINavigationItem) -> DostupnoSearchBar {
        let dostupnoSearchBar = DostupnoSearchBar()
        navigationItem.titleView = dostupnoSearchBar
        return dostupnoSearchBar
    }
    
    private func makeSearchPlacesView(owner mainView: UIView) -> SearchPlacesView {
        let placesView = SearchPlacesView(frame: .zero)
        placesView.isHidden = true
        mainView.addSubview(placesView, edgeInsets: .zero)
        return placesView
    }
    
    private func makeStopSeachButton(owner mainView: UIView) -> UIButton {
        let stopSearchButton = UIButton(frame: .zero)
        stopSearchButton.isHidden = true
        stopSearchButton.alpha = 0.1
        stopSearchButton.addTarget(self, action: #selector(stopSearch), for: .touchUpInside)        
        mainView.addSubview(stopSearchButton, edgeInsets: .zero)
        return stopSearchButton
    }
    
    @objc private func stopSearch() {
        state = .initial
    }
    
    private func configureSearchBar() {
        searchBar?.onStartEditing = { [weak self] in
            self?.state = .emptyEdit
        }
        searchBar?.onCancelTapped = { [weak self] in
            self?.state = .initial
        }
        searchBar?.onTextEditing = { [weak self] text in
            self?.state = .edit
            self?.searchPlacesPresenter.getLocations(by: text)
        }
    }
    
    private func configurePlaceListView() {
        searchPlacesView?.onPlaceDidSelect = { [weak self] placeId in
            let location = self?.searchPlacesPresenter.getLocation(by: placeId)
            if let location = location {
                self?.onPlaceDidSelect?(location)
            }
        }
        searchPlacesView?.onShowAllPlacesDidTap = { [weak self] in
            let response = self?.searchPlacesPresenter.getLocationsResponse
            let text = self?.searchBar?.text
            if let response = response {
                self?.state = .initial
                self?.onShowAllPlacesDidTap?(text, response)
            }
        }
    }
}
