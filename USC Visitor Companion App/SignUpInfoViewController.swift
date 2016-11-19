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
}

class SignUpInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    let types: [UserType] = [.prospective, .current, .parent]
    
    var typeIndex: Int = 0
    
    let interests: [String] = InterestsData.shared.interestNames()
    
    var interestIndex: Int = 0
    
    var delegate: SignUpInfoViewControllerDelegate?
    
    var whiteSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    
    // MARK: IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var typeTableView: UITableView! {
        didSet {
            self.typeTableView.delegate = self
            self.typeTableView.dataSource = self
            self.typeTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var interestTableView: UITableView! {
        didSet {
            self.interestTableView.delegate = self
            self.interestTableView.dataSource = self
            self.interestTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var signUpButton: ShadowButton! {
        didSet {
            self.signUpButton.layer.cornerRadius = 5.0
            self.signUpButton.addShadow()
        }
    }
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.whiteSpinner.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let delegate = delegate {
            delegate.userDidSaveInfo()
        }
    }
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.interestTableView {
            self.interestIndex = indexPath.row
        } else if tableView == self.typeTableView {
            self.typeIndex = indexPath.row
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.interestTableView {
            return self.interests.count
        } else if tableView == self.typeTableView {
            return self.types.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.interestTableView {
            let interestCell = self.interestTableView.dequeueReusableCell(withIdentifier: "Interest Cell")
            interestCell?.textLabel?.text = self.interests[indexPath.row]
            interestCell?.accessoryType = (indexPath.row == self.interestIndex) ? .checkmark : .none
            return interestCell!
        } else if tableView == self.typeTableView {
            let typeCell = self.typeTableView.dequeueReusableCell(withIdentifier: "Type Cell")
            typeCell?.textLabel?.text = self.types[indexPath.row].rawValue
            typeCell?.accessoryType = (indexPath.row == self.typeIndex) ? .checkmark : .none
            return typeCell!
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    
    // MARK: IBAction Methods
    @IBAction func backgroundButtonPressed() {
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
    }
    
    @IBAction func signUpButtonPressed() {
        let firstName = self.firstNameTextField.text
        let lastName = self.lastNameTextField.text
        if let firstName = firstName, let lastName = lastName {
            if firstName.isEmpty || lastName.isEmpty {
                self.showAlert(withTitle: "Missing Fields", message: "Please enter your first and last name to sign up", action: "OK")
            } else {
                self.showSpinnerForSignUpButton()
                User.current.name = firstName + " " + lastName
                User.current.type = self.types[self.typeIndex]
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
    
    func showSpinnerForSignUpButton() {
        self.signUpButton.setTitle("", for: .normal)
        self.whiteSpinner.frame = self.signUpButton.bounds
        self.signUpButton.addSubview(self.whiteSpinner)
        self.signUpButton.isEnabled = false
    }

}
