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
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        doneButton.isEnabled = false
        // Do any additional setup after loading the view.
        self.currentPasswordTextField.delegate = self;  // set delegate of text field
        self.newPasswordTextField.delegate = self;
        self.confirmPasswordTextField.delegate = self;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButton.isEnabled = true;
    }
    
    @IBAction func changePasswordAction(_ sender: AnyObject) {
        if User.current.exists {
            //            if User.current.password == currentPasswordTextField.text { // current password is legit
            //
            //            }
            if newPasswordTextField.text == confirmPasswordTextField.text { // both password is same
                
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
