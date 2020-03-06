//
//  InstagramPost.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct InstagramPost {
    let username: String
    let userId: String
    let caption: String
    let photoURL: String
}
extension InstagramPost {
    init(_ dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? "no username"
        self.userId = dictionary["userId"] as? String ?? "no user id"
        self.caption = dictionary["caption"] as? String ?? "caption"
        self.photoURL = dictionary["photoURL"] as? String ?? "photo"
    }
}
