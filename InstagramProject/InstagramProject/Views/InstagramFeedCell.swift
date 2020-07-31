//
//  InstagramFeedCell.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class InstagramFeedCell: UICollectionViewCell {
 
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    public func configureCell(post: InstagramPost) {
        optionsButton.isHidden = true
        if let user = Auth.auth().currentUser {
            profilePic.kf.setImage(with: user.photoURL)
        } else {
            profilePic.backgroundColor = .systemGray
            userNameLabel.text = "username"
        }
        userNameLabel.text = post.username
        postImage.kf.setImage(with: URL(string:post.photoURL))
        captionLabel.text = post.caption
    }
}
