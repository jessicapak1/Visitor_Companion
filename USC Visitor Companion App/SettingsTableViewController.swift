//
//  SettingsTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit


class SettingsTableViewController: UITableViewController, LoginViewDelegate {
    
    @IBOutlet weak var adminButton: UIBarButtonItem!
    // MARK: UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.tableView.cellForRow(at: indexPath)
        
        if selectedCell?.textLabel?.text == "Edit Profile" {
            self.showEditProfile()
        } else if selectedCell?.textLabel?.text == "Connect with Facebook" {
            self.showConnectWithFacebook()
        } else if selectedCell?.textLabel?.text == "Logout" {
            self.showLogout()
        }
        
        if User.current.type == .admin {
            self.adminButton.title = "Admin"
            self.adminButton.isEnabled = true
        } else {
            self.adminButton.title = ""
            self.adminButton.isEnabled = false
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: General Methods
    func showEditProfile() {
        if User.current.exists {
            self.performSegue(withIdentifier: "Show Edit Profile", sender: nil)
        } else {
            self.showAlert(withTitle: "Error", message: "You are not logged in with an account")
        }
    }
    
    func showLogout() {
        if User.current.exists {
            User.logout()
            self.adminButton.title = ""
            self.adminButton.isEnabled = false
            self.showAlert(withTitle: "Logout", message: "You have successfully logged out")
        } else {
            self.showAlert(withTitle: "Error", message: "You are not logged in with an account")
        }
    }
    
    func showConnectWithFacebook() {
        if User.current.exists {
            // connect account with Facebook ----------------------------------------------------------------------------
        } else {
            self.showAlert(withTitle: "Error", message: "You are not logged in with an account")
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func userDidLoggedIn() {
        print("inside logged in")
        if User.current.type == .admin {
            self.adminButton.title = "Admin"
            self.adminButton.isEnabled = true
        } else {
            self.adminButton.title = ""
            self.adminButton.isEnabled = false
        }
    }
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "settings_to_login") {
            let destinationVC:SettingsTableViewController = segue.destination as! SettingsTableViewController
        }
    }*/
}
