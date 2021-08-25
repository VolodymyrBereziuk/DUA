//
//  CommentsViewController.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit
import SwiftMessages
import KafkaRefresh

class CommentsViewController: UIViewController, CommentsViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: CommentsPresenterProtocol?
    
    var emptyScreenView: EmptyScreenView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupNavigationBar()
        presenter?.getComments()
    }
    
    func configureViews() {
        tableView.register(CommentCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = .init(left: 0, right: 0, top: 10, bottom: 0)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.backgroundColor = R.color.white247()
        addBottomRefresControl()
    }
    
    func setupNavigationBar() {
        navigationItem.title = R.string.localizable.commentsTitle.localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self,
                                                           action: #selector(backTapped))
        if PersistenceManager.manager.isLoggedIn {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.add(),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(addCommentTapped))
        }
    }
    
    func addBottomRefresControl() {
        let refreshHandler: () -> Void = { [weak self] in
            self?.presenter?.getComments()
        }
        tableView.bindFootRefreshHandler(refreshHandler, themeColor: (R.color.ickyGreen() ?? .green), refreshStyle: .native)
        tableView.footRefreshControl.autoRefreshOnFoot = true
    }
    
    func reloadTableView() {
        tableView.reloadData()
        tableView.footRefreshControl.endRefreshing()
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addCommentTapped() {
        presenter?.didSelectCreateComment()
    }
    
    func showAlert(with error: Error) {
        SwiftMessages.show(warning: presenter?.errorTitle(from: error))
    }
    
    func showEmptyView(with title: String?, actionTitle: String?, action: (() -> Void)?) {
        let emptyView = EmptyScreenView(frame: .zero)
        emptyView.set(title: title, actionTitle: actionTitle, action: action)
        view.addSubview(emptyView, edgeInsets: .zero)
        emptyScreenView = emptyView
    }
    
    func hideEmptyView() {
        emptyScreenView?.removeFromSuperview()
    }
    
    func showLoadingView() {
        ProgressView.show(in: view)
    }
    
    func hideLoadingView() {
        ProgressView.hide(for: view)
    }
}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(CommentCell.self, for: indexPath)
        let viewModel = presenter?.cellData(at: indexPath.row)
        if let cell = cell as? CommentCell, let viewModel = viewModel {
            cell.bind(to: viewModel)
        }
        return cell
    }
}

extension CommentsViewController {
    
    static func make(presenter: CommentsPresenterProtocol) -> CommentsViewController? {
        let viewController = R.storyboard.comments.commentsViewController()
        viewController?.presenter = presenter
        presenter.managedView = viewController
        return viewController
    }
}
