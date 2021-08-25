//
//  NewCommentPresenter.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol NewCommentNavigation {
    var didTapBack: (() -> Void)? { get set }
}

protocol NewCommentViewProtocol: AnyObject {
    var presenter: NewCommentPresenterProtocol? { get set }
    
    func set(locationName: String?)
    func showErrorAlert(with text: String?)
    func showSuccessAlert()
    func hideLoading()
    func showLoading()
}

protocol NewCommentPresenterProtocol: AnyObject {
    var managedView: NewCommentViewProtocol? { get set }
    
    func viewDidLoad()
    func didTapBack()
    func send(comment: String)
}

class NewCommentPresenter {
    weak var managedView: NewCommentViewProtocol?
    let navigation: NewCommentNavigation
    let location: Location?
    
    init(navigation: NewCommentNavigation, location: Location?) {
        self.navigation = navigation
        self.location = location
    }
}

extension NewCommentPresenter: NewCommentPresenterProtocol {
    
    func viewDidLoad() {
        managedView?.set(locationName: location?.title)
    }
    
    func didTapBack() {
        navigation.didTapBack?()
    }
    
    func send(comment: String) {
        guard let locationId = location?.id, !comment.isEmpty else { return }
        managedView?.showLoading()
        let addCommentConnection = AddCommentConnection(locationId: locationId, content: comment)
        APIClient.shared.start(connection: addCommentConnection,
                               successHandler: { [weak self] _ in
                                self?.managedView?.hideLoading()
                                self?.managedView?.showSuccessAlert()
            },
                               failureHandler: { [weak self] error in
                                self?.managedView?.hideLoading()
                                let errorTitle = self?.errorTitle(for: error)
                                self?.managedView?.showErrorAlert(with: errorTitle)
        })
    }
    
    private func errorTitle(for error: Error) -> String {
        let title: String
        switch error {
        case AddCommentError.commentsAreNotAllowed:
            title = R.string.localizable.errorCommentsNewNotAllowed.localized()
        case AddCommentError.commentIsEmpty:
            title = R.string.localizable.errorCommentsNewIsEmpty.localized()
        case AddCommentError.notAuthorized:
            title = R.string.localizable.errorCommentsNewNotAuthorized.localized()
        default:
            title = R.string.localizable.genericErrorUnknown.localized()
        }
        return title
    }
}
