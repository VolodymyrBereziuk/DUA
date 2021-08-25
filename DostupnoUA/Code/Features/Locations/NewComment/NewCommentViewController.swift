//
//  NewCommentViewController.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import SwiftMessages

class NewCommentViewController: UIViewController, NewCommentViewProtocol {
    
    enum Constants {
        static let textInsetValue: CGFloat = 12
        static let textViewRadius: CGFloat = 9
        static let textViewBorderWidth: CGFloat = 1
        static let textViewMinHeight: CGFloat = 100
    }
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var clearTextButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTextViewBottom: NSLayoutConstraint!
    
    let placeholderText = R.string.localizable.commentsNewInputPlaceholder.localized()
    
    var presenter: NewCommentPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        confugureViews()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        presenter?.viewDidLoad()
    }
    
    func confugureViews() {
        locationNameLabel.font = .h1CenteredBold
        locationNameLabel.textColor = R.color.warmGrey()
        
        commentTitle.font = .p2LeftBold
        commentTitle.textColor = R.color.warmGrey()
        
        commentImageView.image = R.image.comment()
        commentTitle.text = R.string.localizable.commentsNewInputTitle.localized()
        
        addCommentButton.setTitle(R.string.localizable.commentsNewTitle.localized(), for: .normal)
        addCommentButton.set(style: .green30)
        addCommentButton.setEnablingMode(to: false)
        
        clearTextButton.isHidden = true
        let inset = Constants.textInsetValue
        commentTextView.delegate = self
        resetTextView()
        commentTextView.textContainerInset = UIEdgeInsets(left: inset, right: inset, top: inset, bottom: inset)
        commentTextView.roundView(radius: Constants.textViewRadius,
                                  color: R.color.ickyGreen(),
                                  borderWidth: Constants.textViewBorderWidth)
    }
    
    func resetTextView() {
        commentTextView.text = placeholderText
        commentTextView.textColor = R.color.silver()
    }
    
    func setupNavigationBar() {
        navigationItem.title = R.string.localizable.commentsNewTitle.localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(backTarget: self,
                                                           action: #selector(backTapped))
    }
    
    @objc func backTapped() {
        presenter?.didTapBack()
    }
    
    func showLoading() {
        ProgressView.show(in: view)
    }
    
    func hideLoading() {
        ProgressView.hide(for: view)
    }
    
    @IBAction func addCommentTapped(_ sender: Any) {
        if let comment = commentTextView.text, !comment.isEmptyOrWhitespace, comment != placeholderText {
            presenter?.send(comment: comment)
        }
    }
    
    @IBAction func clearTextTapped(_ sender: Any) {
        resetTextView()
        resizeCommentTextViewd()
        clearTextButton.isHidden = true
        commentTextView.resignFirstResponder()
        addCommentButton.setEnablingMode(to: false)
    }
    
    func set(locationName: String?) {
        locationNameLabel.text = locationName
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        if let infoKey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            commentTextViewBottom.constant = keyboardFrame.height
        }
    }
}

extension NewCommentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == placeholderText else { return }
        textView.text = ""
        textView.textColor = R.color.warmGrey()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let isEmptyOrWhiteSpace = textView.text.isEmptyOrWhitespace
        addCommentButton.setEnablingMode(to: !isEmptyOrWhiteSpace)
        if textView.text.isEmpty {
            resetTextView()
            addCommentButton.setEnablingMode(to: false)
        } else {
            addCommentButton.setEnablingMode(to: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        clearTextButton.isHidden = textView.text.isEmpty
        resizeCommentTextViewd()
    }
    
    func resizeCommentTextViewd() {
        var height = commentTextView.contentSize.height
        height = height < Constants.textViewMinHeight
            ? Constants.textViewMinHeight
            : height
        UIView.animate(withDuration: 0.2) {
            self.commentTextViewHeight.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func showErrorAlert(with text: String?) {
        SwiftMessages.show(warning: text)
    }
    
    func showSuccessAlert() {
        let title = R.string.localizable.commentsNewSendSuccessTitle.localized()
        let actionTitle = R.string.localizable.commentsNewSendSuccessButtonTitle.localized()
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] _ in
            self?.backTapped()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewCommentViewController {
    
    static func make(presenter: NewCommentPresenterProtocol) -> NewCommentViewController? {
        let viewController = R.storyboard.newComment.newCommentViewController()
        viewController?.presenter = presenter
        presenter.managedView = viewController
        return viewController
    }
}
