//
//  UITableView+Extensions.swift
//  OpenWeatherMap
//
//  Created by admin on 6/17/19.
//  Copyright © 2019 Viktor Drykin. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<View: ReusableView>(_ type: View.Type) {
        if type is UITableViewCell.Type {
            register(type.nib, forCellReuseIdentifier: type.reuseKey)
        } else {
            register(type.nib, forHeaderFooterViewReuseIdentifier: type.reuseKey)
        }
    }
    
    func dequeueCell<Cell: ReusableView>(_ type: Cell.Type, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: type.reuseKey, for: indexPath)
    }
    
    func setSelfSized(tableHeaderView headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView = headerView
        
        headerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        headerView.layoutIfNeeded()
        tableHeaderView = headerView
    }
    
    func layoutHeaderFooterView() {
        layoutHeaderView()
        layoutFooterView()
    }
    
    func layoutHeaderView() {
        if let headerView = tableHeaderView {
            let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            setHeader(headerView, withHeight: size.height)
        }
    }
    
    func layoutFooterView() {
        guard let footerView = tableFooterView else {
            return
        }
        layoutIfNeeded()
        let minimumHeight = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let tableViewContentHeightWithoutFooter = contentSize.height - footerView.frame.height
        let possibleHeight = frame.height - tableViewContentHeightWithoutFooter - safeAreaInsets.top - safeAreaInsets.bottom - contentInset.top - contentInset.bottom
        let necessaryHeight = max(minimumHeight, possibleHeight)
        setFooter(footerView, withHeight: necessaryHeight)
    }
    
    private func setHeader(_ header: UIView, withHeight height: CGFloat) {
        if header.frame.size.height != height {
            header.frame.size.height = height
            tableHeaderView = header
            layoutIfNeeded()
        }
    }
    
    private func setFooter(_ footer: UIView, withHeight height: CGFloat) {
        if footer.frame.size.height != height {
            footer.frame.size.height = height
            tableFooterView = footer
            layoutIfNeeded()
        }
    }
}
