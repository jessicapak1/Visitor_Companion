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

class SignUpViewController: UIViewController, SignUpInfoViewControllerDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var signUpButton: ShadowButton! {
        didSet {
            self.signUpButton.layer.cornerRadius = 5.0
            self.signUpButton.addShadow()
        }
    }
    
    @IBOutlet weak var facebookSignUpButton: ShadowButton! {
        didSet {
            self.facebookSignUpButton.layer.cornerRadius = 5.0
            self.facebookSignUpButton.addShadow()
        }
    }
    
    
    // MARK: Properties
    var delegate: SignUpViewControllerDelegate?
    
    var whiteSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whiteSpinner.startAnimating()
    }
    
    
    // MARK: UINavigationController Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Sign Up Info" {
            let SUIVC = segue.destination as! SignUpInfoViewController
            SUIVC.delegate = self
        }
    }
    
    
    // MARK: SignUpInfoViewControllerDelegate Methods
    func userDidSaveInfo() {
        if User.current.exists && User.current.name == "" {
            User.current.delete()
        } else if let delegate = self.delegate {
            delegate.userDidSignUp()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: IBAction Methods
    @IBAction func signUpButtonPressed() {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let confirmedPassword = self.confirmPasswordTextField.text
        if let email = email, let password = password, let confirmedPassword = confirmedPassword {
            if email.isEmpty || password.isEmpty || confirmedPassword.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter your information in all fields to sign up", action: "OK")
            } else {
                if password != confirmedPassword {
                    self.showAlert(withTitle: "Mismatched Passwords", message: "The passwords you entered do not match", action: "OK")
                } else {
                    self.showSpinnerForSignUpButton()
                    User.signup(username: email, password: password, callback: {
                        self.checkSignUpDetails()
                    })
                }
            }
        }
    }
    
    @IBAction func backgroundButtonPressed() {
        self.emailTextField.resignFirstResponder()
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
        self.whiteSpinner.frame = self.signUpButton.bounds
        self.signUpButton.addSubview(self.whiteSpinner)
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
        self.whiteSpinner.removeFromSuperview()
        self.signUpButton.isEnabled = true
        self.facebookSignUpButton.isEnabled = true
    }
    
    func checkSignUpDetails() {
        self.resetSignUpButtons()
        if User.current.exists {
            self.performSegue(withIdentifier: "Show Sign Up Info", sender: nil)
        } else {
            User.logout() // remove token in case Facebook login was correct but local account was already created
            self.showAlert(withTitle: "Sign Up Failed", message: "Unable to sign up with the email provided", action: "Try Again")
        }
    }
    
}
