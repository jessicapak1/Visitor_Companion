//
//  RegistrationViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {

  
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAction(_ sender: AnyObject) {
        let username = usernameTextField.text;
        let password = passwordTextField.text
        let email = emailTextField.text
        let userType = "parent";
        // other fields can be set just like with PFObject
        
        if((emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (usernameTextField.text?.isEmpty)!)
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
                
            }
        } else
        {
            User.signup(name: username!, username: username!, password: password!, email: email!, type: UserType(rawValue: userType)!)
        }
    }
}
