//
//  MenuViewController.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import BubbleTransition

enum MenuCell: String {
    case login = "Login Cell"
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuLoginTableViewCellDelegate {
    
    @IBOutlet weak var adminButton: UIBarButtonItem!
    
    
    // MARK: Properties
    let bubbleTransition = BubbleTransition()
    
    let cells: [MenuCell] = [.login]
    
    
    // MARK: IBOutlets
    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            self.menuTableView.delegate = self
            self.menuTableView.dataSource = self
            self.menuTableView.register(UINib(nibName: "MenuLoginTableViewCell", bundle: nil), forCellReuseIdentifier: "Login Cell")
        }
    }
    
    @IBOutlet weak var menuButton: UIButton!

    
    // MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        nameLabel.isEnabled = false
//        nameLabel.isHidden = true
//        
//        loginButton.isEnabled = false
//        loginButton.isHidden = true
//        if User.current.exists { // logged in
//            nameLabel.isEnabled = true
//            nameLabel.isHidden = false
//            
//            if User.current.name != nil {
//                self.nameLabel.text = User.current.name
//            }
//            
//            loginButton.isEnabled = false
//            loginButton.isHidden = true
//        } else {
//            nameLabel.isEnabled = false
//            nameLabel.isHidden = true
//            
//            loginButton.isEnabled = true
//            loginButton.isHidden = false
//        }
    }
    
    
    // MARK: UITableViewDelegate Methods
    
    
    // MARK: UITableVIewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cells[indexPath.row]
        let identifier = self.cells[indexPath.row].rawValue
        
        if cell == .login {
            let loginCell = self.menuTableView.dequeueReusableCell(withIdentifier: identifier) as! MenuLoginTableViewCell
            loginCell.delegate = self
            return loginCell
        }
        
        return UITableViewCell() // DELETE ASAP
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.cells[indexPath.row]
        
        if cell == .login {
            return MenuLoginTableViewCell.defaultHeight
        }
        
        return 50.0 // DELETE ASAP
    }
    
    
    // MARK: MenuLoginTableViewCellDelegate Methods
    func loginButtonPressed() {
        self.performSegue(withIdentifier: "Show Login", sender: nil)
    }
    
    func signupButtonPressed() {
        self.performSegue(withIdentifier: "Show Login", sender: nil)  // self.performSegue(withIdentifier: "Show Sign Up", sender: nil)
    }
    
    
    // MARK: IBAction Methods
    @IBAction func menuButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings")
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func adminButtonPressed(_ sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "admin")
        self.present(viewController, animated: true, completion: nil)
    }

 
}
