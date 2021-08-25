//
//  CommentModels.swift
//  DostupnoUA
//
//  Created by admin on 19.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

struct CommentCellViewModel {
    let publisherViewModel: CommentViewModel
    let answerViewModel: CommentViewModel?
}

struct CommentViewModel {
    let publisherIcon: String?
    let publisherName: String?
    let commentDate: String?
    let comment: String?
}
