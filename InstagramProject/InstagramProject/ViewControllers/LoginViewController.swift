//
//  ViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var signUpHere: UIButton!
    @IBOutlet weak var logoImageTopConstraint: NSLayoutConstraint!
    
    private var isKeyboardThere = false
    private var originalState: NSLayoutConstraint!
    private var accountState: AccountState = .existingUser
    private var databaseService = DatabaseService()
    private var authSession = AuthenticationSession()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
        logoImageTopConstraint.constant -= originalState.constant
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    private func moveKeyboardUp(height: CGFloat) {
        if isKeyboardThere {return}
        originalState = logoImageTopConstraint
        isKeyboardThere = true
        logoImageTopConstraint.constant -= height
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    //MARK:- Button Outlets
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                showAlert(title: "Missing Fields", message: "all fields are required")
                return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExisitingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToInstagram()
                    }
                }
            }
        } else {
            authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let authDataResult):
                    DispatchQueue.main.async {
                        self?.createUser(authDataResult: authDataResult)
                    }
                }
            }
        }
    }
    private func createUser(authDataResult: AuthDataResult) {
        databaseService.createDatabaseUser(authDataResult: authDataResult){ [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "unable to create a user", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToInstagram()
                }
            }
        }
    }
    private func navigateToInstagram() {
        UIViewController.showViewController(storyboardName: "Instagram", viewcontrollerID: "Instagram")
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        accountState = accountState == .existingUser ? .newUser : .existingUser
        if accountState == .existingUser {
            loginButton.setTitle("Login", for: .normal)
            label.text = "Don't have an account?"
            signUpHere.setTitle("Sign up here", for: .normal)
        } else {
            loginButton.setTitle("Create Account", for: .normal)
            label.text = "Already have an account?"
            signUpHere.setTitle("Login here", for: .normal)
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
