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
    case account = "Account Cell"
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuLoginTableViewCellDelegate, LoginViewControllerDelegate, SignUpViewControllerDelegate, MenuInterestTableViewCellDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var menuTableView: UITableView! {
        didSet {
            self.menuTableView.delegate = self
            self.menuTableView.dataSource = self
            self.menuTableView.register(UINib(nibName: "MenuLoginTableViewCell", bundle: nil), forCellReuseIdentifier: "Login Cell")
            self.menuTableView.register(UINib(nibName: "MenuInterestTableViewCell", bundle: nil), forCellReuseIdentifier: "Interest Cell")
            self.menuTableView.register(UINib(nibName: "MenuAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "Account Cell")
        }
    }
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var adminButton: UIBarButtonItem!
    
    
    // MARK: Properties
    let bubbleTransition: BubbleTransition = BubbleTransition()
    
    var cells: [MenuCell] = [] {
        didSet {
            self.menuTableView.reloadData()
        }
    }
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureMenuCells()
    }
    
    
    // MARK: Navigation Controller Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Login" {
            let NVC = segue.destination as! UINavigationController
            let LVC = NVC.viewControllers.first as! LoginViewController
            LVC.navigationItem.title = "Login"
            LVC.delegate = self
        } else if segue.identifier == "Show Sign Up" {
            let NVC = segue.destination as! UINavigationController
            let SUVC = NVC.viewControllers.first as! SignUpViewController
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
        
        switch cell {
        case .login:
            return self.configureLoginCell(withIdentifier: identifier)
        case .interest:
            return self.configureInterestCell(withIdentifier: identifier)
        case .account:
            return self.configureAccountCell(withIdentifier: identifier)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = self.cells[indexPath.row]
        
        switch cell {
        case .login:
            return MenuLoginTableViewCell.defaultHeight
        case .interest:
            return MenuInterestTableViewCell.defaultHeight
        case .account:
            return MenuAccountTableViewCell.defaultHeight
        }
    }
    
    func configureLoginCell(withIdentifier identifier: String) -> MenuLoginTableViewCell {
        let loginCell = self.menuTableView.dequeueReusableCell(withIdentifier: identifier) as! MenuLoginTableViewCell
        loginCell.delegate = self
        return loginCell
    }
    
    func configureInterestCell(withIdentifier identifier: String) -> MenuInterestTableViewCell {
        let interestCell = self.menuTableView.dequeueReusableCell(withIdentifier: identifier) as! MenuInterestTableViewCell
        interestCell.delegate = self
        interestCell.interestButton.setTitle(User.current.interest, for: .normal)
        return interestCell
    }
    
    func configureAccountCell(withIdentifier identifier: String) -> MenuAccountTableViewCell {
        let accountCell = self.menuTableView.dequeueReusableCell(withIdentifier: identifier) as! MenuAccountTableViewCell
        accountCell.nameLabel.text = User.current.name
        accountCell.usernameLabel.text = User.current.username
        return accountCell
    }
    
    
    // MARK: MenuLoginTableViewCellDelegate Methods
    func loginButtonPressed() {
        self.performSegue(withIdentifier: "Show Login", sender: nil)
    }
    
    func signUpButtonPressed() {
        self.performSegue(withIdentifier: "Show Sign Up", sender: nil)
    }
    
    
    // MARK: MenuInterestTableViewCellDelegate Methods
    func interestButtonPressed() {
        // show interest selection table
    }
    
    
    // MARK: LoginViewControllerDelegate Methods
    func userDidLogin() {
        self.configureMenuCells()
    }
    
    
    // MARK: SignUpViewControllerDelegate Methods
    func userDidSignUp() {
        self.configureMenuCells()
    }
    
    
    // MARK: Menu Methods
    func configureMenuCells() {
        if User.current.exists {
            self.cells = [.account, .interest]
        } else {
            self.cells = [.login]
        }
    }
    
    
    // MARK: IBAction Methods
    @IBAction func menuButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func adminButtonPressed(_ sender: AnyObject) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "admin")
        self.present(viewController, animated: true, completion: nil)
    }

 
}
