//
//  EditProfileViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/5/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var db = DatabaseService()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    private var selectedImage: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.profilePictureView.image = self.selectedImage
            }
        }
    }
    private var storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        updateUI()
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        profilePictureView.kf.setImage(with: user.photoURL)
        usernameTextfield.text = user.displayName
        emailTextfield.text = user.email
        emailTextfield.isUserInteractionEnabled = false
    }
    
    @IBAction func changeProfilePictureButton(_ sender: UIButton) {
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
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let username = usernameTextfield.text, !username.isEmpty,
            let userBio = bioTextField.text, !userBio.isEmpty,
            let fullName = fullNameTF.text, !fullName.isEmpty else {
                showAlert(title: "Missing Fields", message: "All fields are required")
                return
        }
        guard let user = Auth.auth().currentUser else {
            return
        }
        if let profilePicture = selectedImage {
            let resizeImage = UIImage.resizeImage(originalImage: profilePicture, rect: profilePictureView.bounds)
            updateProfilePicture(userId: user.uid, selectedImage: resizeImage)
        }
        updateUserInfo(userID: user.uid, username: username, userBio: userBio, fullName: fullName)
    }
    private func updateProfilePicture(userId: String, selectedImage: UIImage) {
        storageService.uploadPhoto(userId: userId, image: selectedImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to upload photo", message: "\(error)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.photoURL = url
                
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Could not save changes", message: "\(error)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Picture Updated", message: "")
                        }
                    }
                })
            }
        }
    }
    private func updateUserInfo(userID: String, username: String, userBio: String, fullName: String) {
        db.updateUserInfo(userId: userID, username: username, userBio: userBio, fullname: fullName) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to update profile", message: "\(error.localizedDescription)")
                }
            case .success:
                DispatchQueue.main.async {
                    self.showAlert(title: "Profile updated!", message: "")
                }
                self.dismiss(animated: true)
            }
        }
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

