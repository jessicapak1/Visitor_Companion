//
//  ViewController.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse
import FacebookLogin


class LoginViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: ShadowButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 5.0
            self.loginButton.addShadow()
        }
    }
    
    @IBOutlet weak var facebookLoginButton: ShadowButton! {
        didSet {
            self.facebookLoginButton.layer.cornerRadius = 5.0
            self.facebookLoginButton.addShadow()
        }
    }
    
    
    // MARK: Properties
    var whiteSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whiteSpinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if User.current.exists {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    // MARK: IBAction Methods
    @IBAction func loginButtonPressed() {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            if username.isEmpty || password.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter your username and password to login", action: "OK")
            } else {
                self.showSpinnerForLoginButton()
                User.login(username: self.usernameTextField.text!, password: self.passwordTextField.text!, callback: {
                    self.checkLoginDetails()
                })
            }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed() {
        
    }
    
    @IBAction func backgroundButtonPressed() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    @IBAction func facebookLoginButtonPressed() {
        self.showSpinnerForFacebookLoginButton()
        User.loginWithFacebook(callback: {
            self.checkLoginDetails()
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
    
    func showSpinnerForLoginButton() {
        self.loginButton.setTitle("", for: .normal)
        self.whiteSpinner.frame = self.loginButton.bounds
        self.loginButton.addSubview(self.whiteSpinner)
        self.loginButton.isEnabled = false
        self.facebookLoginButton.isEnabled = false
    }
    
    func showSpinnerForFacebookLoginButton() {
        self.facebookLoginButton.setTitle("", for: .normal)
        self.whiteSpinner.frame = self.facebookLoginButton.bounds
        self.facebookLoginButton.addSubview(self.whiteSpinner)
        self.facebookLoginButton.isEnabled = false
        self.loginButton.isEnabled = false
    }
    
    func removeSpinnersFromLoginButtons() {
        self.loginButton.setTitle("Login", for: .normal)
        self.facebookLoginButton.setTitle("Login with Facebook", for: .normal)
        self.whiteSpinner.removeFromSuperview()
        self.loginButton.isEnabled = true
        self.facebookLoginButton.isEnabled = true
    }
    
    func checkLoginDetails() {
        self.removeSpinnersFromLoginButtons()
        if User.current.exists {
            self.dismiss(animated: true, completion: nil)
        } else {
            User.logout() // remove token in case Facebook login was correct but information was changed
            self.showAlert(withTitle: "Login Failed", message: "The username or password you entered was incorrect", action: "Try Again")
        }
    }
 
}

