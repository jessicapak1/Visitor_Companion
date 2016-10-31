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

protocol LoginViewControllerDelegate {
    func userDidLogin()
}

class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var facebookLoginButton: UIButton! {
        didSet {
            self.facebookLoginButton.layer.cornerRadius = 5.0
        }
    }
    
    
    // MARK: Properties
    var delegate: LoginViewControllerDelegate?
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: IBAction Methods
    @IBAction func loginButtonPressed() {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text {
            if username.isEmpty || password.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter both your username and password to login", action: "OK")
            } else {
                self.checkLoginDetails()
            }
        }
    }
    
    @IBAction func forgotLoginDetailsButtonPressed() {
        
    }
    
    @IBAction func backgroundButtonPressed() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    @IBAction func facebookLoginButtonPressed() {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self, completion: {
            (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("LoginViewController - user cancelled login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("LoginViewController - user logged in")
                // prepare current user with logged in facebook user
            }
        })
    }
    
    
    // MARK: General Methods
    func showAlert(withTitle title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkLoginDetails() {
        User.login(username: self.usernameTextField.text!, password: self.passwordTextField.text!)
        if User.current.exists {
            if let delegate = self.delegate {
                delegate.userDidLogin()
                let _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showAlert(withTitle: "Login Failed", message: "The username or password you entered was incorrect", action: "Try Again")
        }
    }
 
}

