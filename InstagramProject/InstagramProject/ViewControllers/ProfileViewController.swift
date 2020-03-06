//
//  ProfileViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    private let profileView = ProfileView()
    
    //public var user: InstagramUser
    public var userPosts = [InstagramPost]() {
        didSet {
            //userPosts = userPosts.filter { $0.userId == user.userId}
            DispatchQueue.main.async {
                self.profileView.collectionView.reloadData()
            }
            if userPosts.isEmpty {
                profileView.collectionView.backgroundView = EmptyView(title: "No posts!", message: "create your own post on the second tab")
            } else {
                profileView.collectionView.backgroundView = nil
            }
        }
    }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    private var selectedImage: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.profileView.profilePictureIV.image = self.selectedImage
            }
        }
    }
        
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.backgroundColor = .white
        configureNavBar()
        updateUI()
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        profileView.profilePictureIV.kf.setImage(with: user.photoURL)
    }
    
    private func configureNavBar() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        navigationItem.title = user.displayName
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(editButtonPressed(_:)))
        profileView.addProfilePictureButton.addTarget(self, action: #selector(editProfilePictureButtonPressed(_:)), for: .touchUpInside)
    }

    @objc private func editButtonPressed(_ sender: UIBarButtonItem) {
       //let editProfileVC = EditProfileViewController()
        let storyboard = UIStoryboard(name: "Instagram", bundle: nil)
        let editProfileVC = storyboard.instantiateViewController(identifier: "EditProfileViewController")
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc private func editProfilePictureButtonPressed(_ sender: UIButton){
        let alertController = UIAlertController(title: "Update Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        let photogallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           alertController.addAction(camera)
        }
        alertController.addAction(photogallery)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }

}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //guarding against optional image user selected
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        
        
        dismiss(animated: true)
    }
    
}
