//
//  SignUpInfoViewController.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 11/3/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

protocol SignUpInfoViewControllerDelegate {
    func userDidSaveInfo()
    func userDidCancelInfo()
}

class SignUpInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    let types: [UserType] = [.prospective, .current, .parent]
    
    var selectedTypeIndex: Int = 0
    
    var delegate: SignUpInfoViewControllerDelegate?
    
    
    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var typeTableView: UITableView! {
        didSet {
            self.typeTableView.delegate = self
            self.typeTableView.dataSource = self
            self.typeTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            self.signUpButton.layer.cornerRadius = 5.0
        }
    }
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = delegate {
            delegate.userDidCancelInfo()
        }
    }
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.typeTableView.deselectRow(at: indexPath, animated: true)
        self.selectedTypeIndex = indexPath.row
        self.typeTableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeCell = self.typeTableView.dequeueReusableCell(withIdentifier: "Type Cell")
        typeCell?.textLabel?.text = self.types[indexPath.row].rawValue
        typeCell?.accessoryType = (indexPath.row == self.selectedTypeIndex) ? .checkmark : .none
        return typeCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    // MARK: IBAction
    @IBAction func backgroundButtonPressed() {
        self.nameTextField.resignFirstResponder()
    }
    
    @IBAction func signUpButtonPressed() {
        let name = self.nameTextField.text
        if let name = name {
            if name.isEmpty {
                self.showAlert(withTitle: "Missing Field", message: "Please enter your name to sign up", action: "OK")
            } else {
                User.current.name = name
                User.current.type = self.types[self.selectedTypeIndex]
                if let delegate = self.delegate {
                    delegate.userDidSaveInfo()
                    let _ = self.navigationController?.popViewController(animated: true)
                }
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
