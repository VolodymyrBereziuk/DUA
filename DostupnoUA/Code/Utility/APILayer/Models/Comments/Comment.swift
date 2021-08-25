//
//  CommentsList.swift
//  DostupnoUA
//
//  Created by admin on 01.09.2020.
//  Copyright © 2020 DostupnoUA. All rights reserved.
//

import Foundation

class Comment: Codable {
    let content: String
    let isApproved: Int
    let authorName: String
    let authorImg: String
    let timestamp: String
    let postID: String
    let parent: Int
    let children: [Comment]

    enum CodingKeys: String, CodingKey {
        case content
        case isApproved = "is_approved"
        case authorName = "author_name"
        case authorImg = "author_img"
        case timestamp
        case postID = "post_id"
        case parent, children
    }

    init(content: String, isApproved: Int, authorName: String, authorImg: String, timestamp: String, postID: String, parent: Int, children: [Comment]) {
        self.content = content
        self.isApproved = isApproved
        self.authorName = authorName
        self.authorImg = authorImg
        self.timestamp = timestamp
        self.postID = postID
        self.parent = parent
        self.children = children
    }
}
