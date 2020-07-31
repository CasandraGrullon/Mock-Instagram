//
//  AddPhotoViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AddPhotoViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var captionTF: UITextField!
    
    private let dbService = DatabaseService()
    private let storageService = StorageService()
    
    private var instaUser: InstagramUser?
    
    private var selectedImage: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.postImageView.image = self.selectedImage
            }
        }
    }
    private var photoLibrary = [UIImage]()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDisabled()
        getUserData()
        nextButton.isEnabled = false
        captionTF.delegate = self
    }
    
    private func cameraDisabled() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
    }
    
    private func getUserData() {
        dbService.fetchCurrentUser { [weak self] (result) in
            switch result {
            case .failure(let error) :
                print("could not get user data: \(error)")
            case .success(let user):
                DispatchQueue.main.async {
                    self?.instaUser = user
                    
                }
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let photoPicked = selectedImage,
            let caption = captionTF.text, !caption.isEmpty else {
                return
        }
        postImageView.image = photoPicked
        
        let resizeImage = UIImage.resizeImage(originalImage: photoPicked, rect: postImageView.bounds)
        
        dbService.createPost(username: instaUser?.username ?? "", userId: instaUser?.userId ?? "", caption: caption) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Could not create post", message: "\(error)")
                }
            case .success(let docID):
                self?.uploadPhoto(photo: resizeImage, documentId: docID)
                self?.tabBarController?.selectedIndex = 0
            }
        }
    }
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto(postId: documentId, image: photo) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Could not upload photo", message: "\(error)")
                }
            case .success(let url):
                self?.updateImageURL(url, documentId: documentId)
            }
        }
    }
    private func updateImageURL(_ url: URL, documentId: String) {
        Firestore.firestore().collection(DatabaseService.instagramPostCollection).document(documentId).updateData(["photoURL": url.absoluteString]) { [weak self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to update item", message: "\(error)")
                }
            }else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                    self?.selectedImage = nil
                    self?.nextButton.isEnabled = false
                    self?.captionTF.text = ""
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func galleryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        let alertController = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //guarding against optional image user selected
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        nextButton.isEnabled = true
        
        dismiss(animated: true)
    }
}
extension AddPhotoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
