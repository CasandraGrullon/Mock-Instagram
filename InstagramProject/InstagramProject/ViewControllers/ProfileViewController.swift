//
//  ProfileViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore

enum CollectionState {
    case threeByThree
    case one
}

class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    private var database = DatabaseService()
    private var listener: ListenerRegistration?
    
    private var instaUser: InstagramUser? {
        didSet {
            updateUI()
        }
    }
    
    public var userPosts = [InstagramPost]() {
        didSet {
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
    private var collectionState: CollectionState = .threeByThree {
        didSet {
            DispatchQueue.main.async {
                self.profileView.collectionView.reloadData()
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
        getUserData()
        profileView.collectionView.delegate = self
        profileView.collectionView.dataSource = self
        collectionState = .threeByThree
        profileView.segmentedControl.addTarget(self, action: #selector(segmentControllerPressed(_:)), for: .valueChanged)
        profileView.collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: "photoGalleryCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
        listener = Firestore.firestore().collection(DatabaseService.instagramPostCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Could not get data", message: "\(error)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { InstagramPost($0.data()) }
                self?.userPosts = posts
                self?.updateUI()
            }
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        listener?.remove()
    }
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        profileView.profilePictureIV.kf.setImage(with: user.photoURL)
        profileView.numberOfPosts.text = "\(userPosts.count)\n#posts"
    }
    
    private func configureNavBar() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        navigationItem.title = user.displayName
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(editButtonPressed(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonPressed))
        profileView.addProfilePictureButton.addTarget(self, action: #selector(editProfilePictureButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc private func segmentControllerPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            collectionState = .threeByThree
        } else {
            collectionState = .one
        }
    }
    @objc private func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "Main", viewcontrollerID: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Oops... unable to sign out", message: "\(error.localizedDescription)")
            }
        }
    }
    
    @objc private func editButtonPressed(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Instagram", bundle: nil)
        let editProfileVC = storyboard.instantiateViewController(identifier: "EditProfileViewController")
        present(UINavigationController(rootViewController: editProfileVC) , animated: true)
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
    
    private func getUserData() {
        database.fetchCurrentUser { [weak self] (result) in
            switch result {
            case .failure(let error) :
                print("could not get user data: \(error)")
            case .success(let user):
                DispatchQueue.main.async {
                    self?.instaUser = user
                    self?.profileView.bioLabel.text = user.userBio
                    self?.profileView.fullNameLabel.text = user.userFullName
                }
            }
        }
    }
    
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
    
}
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionState == .threeByThree {
            let itemSpacing: CGFloat = 11
            let maxSize: CGFloat = UIScreen.main.bounds.size.width
            let numberOfItems: CGFloat = 3
            let totalSpace: CGFloat = (2 * itemSpacing) + (numberOfItems - 1) * itemSpacing//(numberOfItems * itemSpacing) * 3
            let itemWidth: CGFloat = (maxSize - totalSpace) / numberOfItems
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            let maxWidth: CGFloat = UIScreen.main.bounds.size.width
            let itemWidth: CGFloat = maxWidth
            return CGSize(width: itemWidth, height: itemWidth * 0.90)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = profileView.collectionView.dequeueReusableCell(withReuseIdentifier: "photoGalleryCell", for: indexPath) as? PhotoGalleryCell else {
            fatalError("could not cast to photoGallery Cell")
        }
        let post = userPosts[indexPath.row]
        cell.imageView.clipsToBounds = true
        cell.imageView.kf.setImage(with: URL(string: post.photoURL))
        return cell
        
    }
    
    
}
