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
import FacebookLogin

protocol SignUpViewControllerDelegate {
    func userDidSignUp()
}

class SignUpViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var confirmEmailTextField: UITextField!
    
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
    
    @IBOutlet weak var facebookSignUpButton: UIButton! {
        didSet {
            self.facebookSignUpButton.layer.cornerRadius = 5.0
        }
    }
    
    
    // MARK: Properties
    var delegate: SignUpViewControllerDelegate?
    
    var graySpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var whiteSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.graySpinner.startAnimating()
        self.whiteSpinner.startAnimating()
    }
    
    
    // MARK: IBAction Methods
    @IBAction func signUpButtonPressed() {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        let confirmedEmail = self.confirmEmailTextField.text
        let password = self.passwordTextField.text
        let confirmedPassword = self.confirmPasswordTextField.text
        if let name = name, let email = email, let confirmedEmail = confirmedEmail, let password = password, let confirmedPassword = confirmedPassword{
            if name.isEmpty || email.isEmpty || confirmedEmail.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter your information in all fields to sign up", action: "OK")
            } else {
                let type = self.segmentedControl.titles[Int(self.segmentedControl.index)]
                if self.passwordTextField.text != self.confirmPasswordTextField.text {
                    self.showAlert(withTitle: "Mismatched Passwords", message: "The passwords you entered do not match", action: "OK")
                } else if self.emailTextField.text != self.confirmEmailTextField.text {
                    self.showAlert(withTitle: "Mismatched Emails", message: "The emails you entered do not match", action: "OK")
                } else {
                    self.showSpinnerForSignUpButton()
                    User.signup(name: name, username: email, password: password, email: email, type: type, callback: {
                        self.checkSignUpDetails()
                    })
                }
            }
        }
    }
    
    @IBAction func backgroundButtonPressed() {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.confirmEmailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
    }
    
    @IBAction func facebookSignUpButtonPressed() {
        self.showSpinnerForFacebookSignUpButton()
        User.signupWithFacebook(callback: {
            self.checkSignUpDetails()
        })
    }
    
    @IBAction func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: General Methods
    func showAlert(withTitle title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSpinnerForSignUpButton() {
        self.signUpButton.setTitle("", for: .normal)
        self.graySpinner.frame = self.signUpButton.bounds
        self.signUpButton.addSubview(self.graySpinner)
        self.signUpButton.isEnabled = false
        self.facebookSignUpButton.isEnabled = false
    }
    
    func showSpinnerForFacebookSignUpButton() {
        self.facebookSignUpButton.setTitle("", for: .normal)
        self.whiteSpinner.frame = self.facebookSignUpButton.bounds
        self.facebookSignUpButton.addSubview(self.whiteSpinner)
        self.facebookSignUpButton.isEnabled = false
        self.signUpButton.isEnabled = false
    }
    
    func resetSignUpButtons() {
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.facebookSignUpButton.setTitle("Sign Up with Facebook", for: .normal)
        self.graySpinner.removeFromSuperview()
        self.whiteSpinner.removeFromSuperview()
        self.signUpButton.isEnabled = true
        self.facebookSignUpButton.isEnabled = true
    }
    
    func checkSignUpDetails() {
        if User.current.exists {
            if let delegate = self.delegate {
                delegate.userDidSignUp()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.resetSignUpButtons()
            User.logout() // remove token in case Facebook login was correct but local account was already created
            self.showAlert(withTitle: "Sign Up Failed", message: "The email you entered is already being used", action: "Try Again")
        }
    }
    
}
