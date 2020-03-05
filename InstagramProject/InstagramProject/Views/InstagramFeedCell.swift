//
//  InstagramFeedCell.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class InstagramFeedCell: UICollectionViewCell {
 
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    public func configureCell(post: InstagramPost) {
        captionLabel.text = post.caption
    }
    
}
