//
//  Comment.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/13/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    let commentText: String
    let commentedBy: String
    let dateCreated: Timestamp
    let postId: String
    let postedBy: String
}
extension Comment {
    init(_ dictionary: [String: Any]) {
        self.commentText = dictionary["commentedText"] as? String ?? "no comment text"
        self.commentedBy = dictionary["commentedBy"] as? String ?? "no commented by"
        self.dateCreated = dictionary["dateCreated"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = dictionary["postId"] as? String ?? "no post id"
        self.postedBy = dictionary["postedBy"] as? String ?? "no posted by"
     }
}
