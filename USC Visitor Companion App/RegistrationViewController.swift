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
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonPressed(_ sender: AnyObject) {
        signup();
    }
    
    func signup() {
        let user = PFUser()
        user.username = emailTextField.text;
        user.password = passwordTextField.text
        user.email = emailTextField.text
        // other fields can be set just like with PFObject
 
        
        user.signUpInBackground {
            (succeeded, error) in
            if let error = error {
                let errorString = error;
                print(errorString);
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                print("Successfully signed up");
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
