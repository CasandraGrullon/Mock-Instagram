//
//  User.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct InstagramUser {
    let username: String
    let userBio: String
    let userId: String
    let userFullName: String
    let userEmail: String
}

extension InstagramUser {
    init(_ dictionary: [String : Any]) {
        self.username = dictionary["username"] as? String ?? "no username"
        self.userBio = dictionary["userBio"] as? String ?? "no bio"
        self.userId = dictionary["userId"] as? String ?? "no id"
        self.userFullName = dictionary["userFullName"] as? String ?? "no name"
        self.userEmail = dictionary["userEmail"] as? String ?? "no email"
    }
}
