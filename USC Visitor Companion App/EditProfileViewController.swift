//
//  EditProfileViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 10/15/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    let types: [UserType] = [.prospective, .current, .parent]
    
    var typeIndex: Int = 0
    
    
    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextFeidl: UITextField!
    
    @IBOutlet weak var typeTableView: UITableView! {
        didSet {
            self.typeTableView.delegate = self
            self.typeTableView.dataSource = self
            self.typeTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.text = User.current.name
        self.emailTextFeidl.text = User.current.email
        for i in 0..<self.types.count {
            if self.types[i] == User.current.type {
                self.typeIndex = i
                break
            }
        }
    }
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.typeTableView.deselectRow(at: indexPath, animated: true)
        self.typeIndex = indexPath.row
        self.typeTableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeCell = self.typeTableView.dequeueReusableCell(withIdentifier: "Type Cell")
        typeCell?.textLabel?.text = self.types[indexPath.row].rawValue
        typeCell?.accessoryType = (indexPath.row == self.typeIndex) ? .checkmark : .none
        return typeCell!
    }
    
    
    // MARK: IBAction Methods
    @IBAction func backgroundButtonPressed() {
        self.nameTextField.resignFirstResponder()
        self.emailTextFeidl.resignFirstResponder()
    }
    
    @IBAction func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed() {
        let name = self.nameTextField.text
        let email = self.emailTextFeidl.text
        if let name = name, let email = email {
            if name.isEmpty || email.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter your name and email to save", action: "OK")
            } else {
                if name != User.current.name {
                    User.current.name = name
                }
                if email != User.current.name {
                    User.current.username = email
                    User.current.email = email
                }
                if self.types[self.typeIndex] != User.current.type {
                    User.current.type = self.types[self.typeIndex]
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: General Methods
    func showAlert(withTitle title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
