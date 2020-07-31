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
    @IBOutlet weak var profileImageTopConstraint: NSLayoutConstraint!
    
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
    private var instaUser: InstagramUser
    private var isKeyboardThere = false
    private var originalState: NSLayoutConstraint!
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    init?(coder: NSCoder, user: InstagramUser) {
        self.instaUser = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        bioTextField.delegate = self
        fullNameTF.delegate = self
        updateUI()
        view.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        registerForKeyBoardNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        unregisterForKeyBoardNotifications()
    }
    //MARK:- Keyboard Handeling
    @objc private func didTap(_ gesture: UITapGestureRecognizer ) {
        usernameTextfield.resignFirstResponder()
        bioTextField.resignFirstResponder()
        fullNameTF.resignFirstResponder()
    }
    private func registerForKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterForKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        moveKeyboardUp(height: keyboardFrame.size.height / 2)
    }
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        resetUI()
    }
    private func resetUI() {
        isKeyboardThere = false
        profileImageTopConstraint.constant -= originalState.constant
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    private func moveKeyboardUp(height: CGFloat) {
        if isKeyboardThere {return}
        originalState = profileImageTopConstraint
        isKeyboardThere = true
        profileImageTopConstraint.constant -= height
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        profilePictureView.kf.setImage(with: user.photoURL)
        usernameTextfield.text = instaUser.username
        emailTextfield.text = instaUser.userEmail
        bioTextField.text = instaUser.userBio
        fullNameTF.text = instaUser.userFullName
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

