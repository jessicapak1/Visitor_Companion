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
    case interest = "Interest Cell"
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuLoginTableViewCellDelegate, LoginViewControllerDelegate, SignUpViewControllerDelegate {
    
    @IBOutlet weak var adminButton: UIBarButtonItem!
    
    
    // MARK: Properties
    let bubbleTransition = BubbleTransition()
    
    var cells: [MenuCell] = []
    
    
    // MARK: IBOutlets
    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            self.menuTableView.delegate = self
            self.menuTableView.dataSource = self
            self.menuTableView.register(UINib(nibName: "MenuLoginTableViewCell", bundle: nil), forCellReuseIdentifier: "Login Cell")
            self.menuTableView.register(UINib(nibName: "MenuInterestTableViewCell", bundle: nil), forCellReuseIdentifier: "Interest Cell")
        }
    }
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.current.exists {
            self.cells = [.interest]
        } else {
            self.cells = [.login]
        }
    }
    
    
    // MARK: Navigation Controller Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Login" {
            let LVC = segue.destination as! LoginViewController
            LVC.navigationItem.title = "Login"
            LVC.delegate = self
        } else if segue.identifier == "Show Sign Up" {
            let SUVC = segue.destination as! SignUpViewController
            SUVC.navigationItem.title = "Sign Up"
            SUVC.delegate = self
        }
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
            return self.configureLoginCell(withIdentifier: identifier)
        } else if cell == .interest {
            return self.configureInterestCell(withIdentifier: identifier)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.cells[indexPath.row]
        
        if cell == .login {
            return MenuLoginTableViewCell.defaultHeight
        } else if cell == .interest {
            return MenuInterestTableViewCell.defaultHeight
        }
        
        return 0.0
    }
    
    func configureInterestCell(withIdentifier identifier: String) -> MenuInterestTableViewCell {
        let interestCell = self.menuTableView.dequeueReusableCell(withIdentifier: identifier) as! MenuInterestTableViewCell
        if User.current.exists {
            interestCell.interestLabel.text = User.current.interest
        } else {
            interestCell.interestLabel.text = "General"
        }
        return interestCell
    }
    
    func configureLoginCell(withIdentifier identifier: String) -> MenuLoginTableViewCell {
        let loginCell = self.menuTableView.dequeueReusableCell(withIdentifier: identifier) as! MenuLoginTableViewCell
        loginCell.delegate = self
        return loginCell
    }
    
    
    // MARK: MenuLoginTableViewCellDelegate Methods
    func loginButtonPressed() {
        self.performSegue(withIdentifier: "Show Login", sender: nil)
    }
    
    func signUpButtonPressed() {
        self.performSegue(withIdentifier: "Show Sign Up", sender: nil)
    }
    
    
    // MARK: LoginViewControllerDelegate Methods
    func userDidLogin() {
        // remove login cell and replace with account cell
//        User.logout()
    }
    
    
    // MARK: SignUpViewControllerDelegate Methods
    func userDidSignUp() {
        // remove login cell and replace with account cell
        User.logout()
    }
    
    
    // MARK: IBAction Methods
    @IBAction func menuButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings")
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func adminButtonPressed(_ sender: AnyObject) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "admin")
        self.present(viewController, animated: true, completion: nil)
    }

 
}
