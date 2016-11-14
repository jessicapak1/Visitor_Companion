//
//  ChangePasswordViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 10/15/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        doneButton.isEnabled = false
        // Do any additional setup after loading the view.
        self.newPasswordTextField.delegate = self;
       
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let initialEmail = newPasswordTextField.text
        let email = initialEmail?.lowercased()
    
        PFUser.requestPasswordResetForEmail(inBackground: email!) {
            (succeeded, error) in
            if (error == nil) {
                print("worked")
            }else {
                print("error")
                print(error)
            }
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButton.isEnabled = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
