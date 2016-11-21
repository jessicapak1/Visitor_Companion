//
//  SettingsTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate {
    func userDidStartTutorial()
}

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var adminButton: UIBarButtonItem!
    
    var delegate: SettingsTableViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adminButton.title = ""
        self.adminButton.isEnabled = false
        if User.current.exists {
            if User.current.type == .admin {
                self.adminButton.title = "Admin"
                self.adminButton.isEnabled = true
            } else {
                self.adminButton.title = ""
                self.adminButton.isEnabled = false
            }
        }
    }
    
    // MARK: UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.tableView.cellForRow(at: indexPath)
        
        if selectedCell?.textLabel?.text == "Login or Sign Up" {
            self.showLoginSignUp()
        } else if selectedCell?.textLabel?.text == "Logout" {
            self.showLogout()
        } else if selectedCell?.textLabel?.text == "Start Tutorial" {
            self.showTutorial()
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func adminButtonPressed(_ sender: Any) {
    }
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: General Methods
    func showLoginSignUp() {
        if User.current.exists {
            self.showAlert(withTitle: "Error", message: "You're already logged in")
        } else {
            self.performSegue(withIdentifier: "Show Login", sender: nil)
        }
    }
    
    func showLogout() {
        if User.current.exists {
            User.logout()
            self.showAlert(withTitle: "Logout", message: "You have successfully logged out")
            self.adminButton.title = ""
            self.adminButton.isEnabled = false
        } else {
            self.showAlert(withTitle: "Error", message: "You're not logged in")
        }
    }
    
    func showTutorial() {
        self.dismiss(animated: true, completion: {
            if let delegate = self.delegate {
                delegate.userDidStartTutorial()
            }
        })
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
