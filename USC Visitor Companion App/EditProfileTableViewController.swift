//
//  EditProfileViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 10/15/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usertypePicker: UIPickerView!
    
    var userTypes = ["Parent", "Prospective Student", "Current Student", "Administrator", "Other"]
    var selectedUserType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        usertypePicker.dataSource = self;
        usertypePicker.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfileAction(_ sender: AnyObject) {
        if User.current.exists {
            if User.current.name != nil {
                User.current.name = nameTextField.text
            }
            if User.current.username != nil {
                User.current.username = usernameTextField.text
            }
            if User.current.email != nil {
                User.current.email = emailTextField.text
            }
            if selectedUserType != "" {
                print(UserType(rawValue: selectedUserType)!)
                User.current.type = UserType(rawValue: selectedUserType)!
            }
        }
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selectedUserType = userTypes[row]
    }
}
