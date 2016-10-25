//
//  SignUpViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse
import BetterSegmentedControl

protocol SignUpViewControllerDelegate {
    func userDidSignUp()
}

class SignUpViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var segmentedControl: BetterSegmentedControl! {
        didSet {
            self.segmentedControl.titleFont = .systemFont(ofSize: 12.0)
            self.segmentedControl.selectedTitleFont = .systemFont(ofSize: 12.0)
            self.segmentedControl.titles = ["Prospective Student", "Parent", "Current Student"]
        }
    }

    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            self.signUpButton.layer.cornerRadius = 5.0
        }
    }
    
    
    // MARK: Properties
    var delegate: SignUpViewControllerDelegate?
    
    
    // MARK: IBAction Methods
    @IBAction func signUpButtonPressed() {
        let name = self.nameTextField.text
        let username = self.usernameTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let confirmedPassword = self.confirmPasswordTextField.text
        if let name = name, let username = username, let email = email, let password = password, let confirmedPassword = confirmedPassword {
            if name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter your information for all fields to sign up", action: "OK")
            } else {
                let type = self.segmentedControl.titles[Int(self.segmentedControl.index)]
                if self.passwordTextField.text == self.confirmPasswordTextField.text {
                    self.checkSignUpDetails(name: name, username: username, password: password, email: email, type: type)
                } else {
                    self.showAlert(withTitle: "Mismatched Passwords", message: "The passwords you entered do not match", action: "OK")
                }
            }
        }
    }
    
    @IBAction func backgroundButtonPressed() {
        self.nameTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
    }
    
    
    // MARK: General Methods
    func showAlert(withTitle title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkSignUpDetails(name: String, username: String, password: String, email: String, type: String) {
        User.signup(name: name, username: username, password: password, email: email, type: type)
        if User.current.exists {
            if let delegate = self.delegate {
                delegate.userDidSignUp()
                let _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showAlert(withTitle: "Sign Up Failed", message: "The username you entered is already being used", action: "Try Again")
        }
    }
    
}
