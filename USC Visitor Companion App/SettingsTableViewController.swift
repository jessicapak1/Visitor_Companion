//
//  SettingsTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = self.tableView.cellForRow(at: indexPath)
        
        if selectedCell?.textLabel?.text == "Edit Profile" {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit_profile")
            self.present(viewController, animated: true, completion: nil)
        } else if selectedCell?.textLabel?.text == "Change Password" {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "change_password")
            self.present(viewController, animated: true, completion: nil)
        } else if selectedCell?.textLabel?.text == "Connect with Facebook" {
        
        } else if selectedCell?.textLabel?.text == "Logout" {
            User.logout();
            let alert = UIAlertController(title: "Logout", message: "You have successfully logged out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
