//
//  CommentCell.swift
//  DostupnoUA
//
//  Created by admin on 11.07.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet private weak var verticalStackView: UIStackView!
    private weak var horizontalStackView: UIStackView?
    private weak var publisherCommentView: CommentView?
    private weak var answerCommentView: CommentView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        verticalStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        let publisherView = CommentView(frame: .zero)
        let answerView = CommentView(frame: .zero)
        let hStackView = UIStackView(arrangedSubviews: [answerView])
        hStackView.isLayoutMarginsRelativeArrangement = true
        hStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0)
        verticalStackView.addArrangedSubview(publisherView)
        verticalStackView.addArrangedSubview(hStackView)
        hStackView.isHidden = true
        
        horizontalStackView = hStackView
        publisherCommentView = publisherView
        answerCommentView = answerView
        
    }
    
    func bind(to viewModel: CommentCellViewModel) {
        publisherCommentView?.bind(to: viewModel.publisherViewModel)
        if let answer = viewModel.answerViewModel {
            horizontalStackView?.isHidden = false
            answerCommentView?.bind(to: answer)
        } else {
            horizontalStackView?.isHidden = true
        }
    }
}
