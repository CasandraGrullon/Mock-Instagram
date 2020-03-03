//
//  ViewController.swift
//  InstagramProject
//
//  Created by casandra grullon on 3/3/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

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
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

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
            authSession.signInExistingUser(email: email, password: password) { [weak self] (result) in
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
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToInstagram()
                    }
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
