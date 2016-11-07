//
//  SettingsTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    // MARK: UITableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.tableView.cellForRow(at: indexPath)
        
        if selectedCell?.textLabel?.text == "Connect with Facebook" {
            self.showConnectWithFacebook()
        } else if selectedCell?.textLabel?.text == "Logout" {
            self.showLogout()
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: General Methods
    func showLogout() {
        if User.current.exists {
            User.logout()
            self.showAlert(withTitle: "Logout", message: "You have successfully logged out")
        } else {
            self.showAlert(withTitle: "Error", message: "You are not logged in with an account")
        }
    }
    
    func showConnectWithFacebook() {
        if User.current.exists {
            // connect account with Facebook ----------------------------------------------------------------------------
        } else {
            self.showAlert(withTitle: "Error", message: "You must be logged in with an account")
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
