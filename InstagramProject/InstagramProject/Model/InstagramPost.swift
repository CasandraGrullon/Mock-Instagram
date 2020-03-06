//
//  InstagramPost.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct InstagramPost {
    //let postId: String
    let userName: String
    let userId: String
    let caption: String
    let photoURL: String
}
extension InstagramPost {
    init(_ dictionary: [String : Any]) {
        //self.postId = dictionary["postId"] as? String ?? "no photo id"
        self.userName = dictionary["userName"] as? String ?? "no username"
        self.userId = dictionary["userId"] as? String ?? "no user id"
        self.caption = dictionary["caption"] as? String ?? "caption"
        self.photoURL = dictionary["photoUrl"] as? String ?? "photo"
    }
}
