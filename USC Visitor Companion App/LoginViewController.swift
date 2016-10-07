//
//  ViewController.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
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

    @IBAction func loginAction(_ sender: AnyObject) {
        login()
    }

    
    func login() {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if((usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!)
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
        } else {
            // Send a request to login
            PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user, error) -> Void in
                if ((user) != nil) {
                    let alertController = UIAlertController(title: "Sucess", message: "Logged In!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true) { }
                    
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map")
                    self.present(viewController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true) { }
                }
            })
        }
    }
}

