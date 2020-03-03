//
//  ProfileViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.backgroundColor = .white

    }


}
