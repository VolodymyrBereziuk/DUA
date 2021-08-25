//
//  CommentsPresenter.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

protocol CommentsNavigation {
    var toCreateComment: (() -> Void)? { get set }
}

protocol CommentsViewProtocol: AnyObject {
    
    var presenter: CommentsPresenterProtocol? { get set }
    
    func reloadTableView()
    func showLoadingView()
    func hideLoadingView()
    func showAlert(with error: Error)
    func showEmptyView(with title: String?, actionTitle: String?, action: (() -> Void)?)
    func hideEmptyView()
}

protocol CommentsPresenterProtocol: AnyObject {
    var managedView: CommentsViewProtocol? { get set }
    var numberOfRows: Int { get }
    
    func cellData(at index: Int) -> CommentCellViewModel?
    func didSelectCreateComment()
    func getComments()
    func errorTitle(from error: Error) -> String
}

class CommentsPresenter {
    
    enum State {
        case loading
        case empty
        case loaded
        case error
    }
    
    let navigation: CommentsNavigation
    let location: Location?
    
    weak var managedView: CommentsViewProtocol?
    
    var cellViewModels = [CommentCellViewModel]()
    var comments: [Comment] = []
    
    var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                managedView?.showLoadingView()
            case .empty:
                managedView?.hideLoadingView()
                managedView?.showEmptyView(with: R.string.localizable.commentsEmptyTitle.localized(),
                                           actionTitle: R.string.localizable.commentsErrorRetry.localized(),
                                           action: getComments)
            case .error:
                managedView?.hideLoadingView()
                managedView?.showEmptyView(with: R.string.localizable.genericErrorUnknown.localized(),
                                           actionTitle: R.string.localizable.commentsErrorRetry.localized(),
                                           action: getComments)
            case .loaded:
                managedView?.hideLoadingView()
                managedView?.hideEmptyView()
                managedView?.reloadTableView()
            }
        }
    }
    
    init(navigation: CommentsNavigation, location: Location?) {
        self.navigation = navigation
        self.location = location
    }
    
    func getComments() {
        guard let locationId = location?.id else { return }
        if comments.isEmpty {
            state = .loading
        }
        
        let commentsConnection = GetCommentsConnection(postId: locationId, offset: comments.count)
        APIClient.shared.start(connection: commentsConnection, successHandler: { [weak self] commentList in
            self?.comments.append(contentsOf: commentList)
            let viewModels = commentList.map { $0.convertToCellViewModel() }
            self?.cellViewModels.append(contentsOf: viewModels)
            
            self?.state = self?.comments.isEmpty == true ? .empty : .loaded
            }, failureHandler: { [weak self] error in
                if self?.comments.isEmpty ?? true {
                    self?.state = .error
                } else {
                    self?.managedView?.showAlert(with: error)
                }
        })
    }
    
    // MARK: - Error
    
    func errorTitle(from error: Error) -> String {
        let message: String
        switch error {
        case GetCommentsConnectionError.emptyPostId:
            message = R.string.localizable.errorCommentsEmptyPostId.localized()
        default:
            message = R.string.localizable.genericErrorUnknown.localized()
        }
        return message
    }
}

extension CommentsPresenter: CommentsPresenterProtocol {
    var numberOfRows: Int {
        return cellViewModels.count
    }
    
    func didSelectCreateComment() {
        navigation.toCreateComment?()
    }
    
    func cellData(at index: Int) -> CommentCellViewModel? {
        return cellViewModels[safe: index]
    }
    
}

private extension Comment {
    
    func convertToCellViewModel() -> CommentCellViewModel {
        let commentViewModel = CommentViewModel(publisherIcon: authorImg,
                                                publisherName: authorName,
                                                commentDate: timestamp,
                                                comment: content)
        var answerViewModel: CommentViewModel?
        if let answer = children.first {
            answerViewModel = CommentViewModel(publisherIcon: answer.authorImg, publisherName: answer.authorName, commentDate: answer.timestamp, comment: answer.content)
        }
        return CommentCellViewModel(publisherViewModel: commentViewModel, answerViewModel: answerViewModel)
    }
    
}
