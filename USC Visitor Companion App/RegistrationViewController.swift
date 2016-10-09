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
        signup()
//        signup(name: usernameTextField.text, username: usernameTextField.text, password: passwordTextField.text, email: emailTextField.text , type: , callback: )
    }
    
    func signup() {
        let user = PFUser()
        user.username = usernameTextField.text;
        user.password = passwordTextField.text
        user.email = emailTextField.text
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
            user.signUpInBackground {
                (succeeded, error) in
                if let error = error {
                    _ = error;
                    
                    let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true) { }
                } else {
                    // Hooray! Let them use the app now.
                    let alertController = UIAlertController(title: "Sucess", message: "Registration Complete!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true) { }
                    
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map")
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
