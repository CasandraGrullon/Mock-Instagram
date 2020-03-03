//
//  TabBarController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var instagramFeedVC: InstagramFeedViewController = {
        let vc = InstagramFeedViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        return vc
    }()

    private lazy var addPhotoVC: AddPhotoViewController = {
       let vc = AddPhotoViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.rectangle"), tag: 1)
        return vc
    }()
    private lazy var profileVC: ProfileViewController = {
       let vc = ProfileViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 2)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [instagramFeedVC, addPhotoVC, UINavigationController(rootViewController: profileVC)]
    }
    

}
