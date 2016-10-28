//
//  AppPreferenceTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class AppPreferenceTableViewController: UITableViewController {

//    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableview.delegate = self
//        self.tableview.datasource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 { // link with facebook
            // do something
        } else if indexPath.section == 0 && indexPath.row == 1 { // link with instagram
            
        } else if indexPath.section == 1 && indexPath.row == 0 { // edit profile
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "edit_profile")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.section == 1 && indexPath.row == 1 { // change password
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "change_password")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.section == 1 && indexPath.row == 2 { // logout
            User.logout();
            let alert = UIAlertController(title: "Logout", message: "You have successfully logged out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.section == 2 && indexPath.row == 0 { // about
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "about")
            self.present(viewController, animated: true, completion: nil)
        } else if indexPath.section == 2 && indexPath.row == 1 { // privacy?
            
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
