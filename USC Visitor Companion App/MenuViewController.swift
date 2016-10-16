//
//  MenuViewController.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import BubbleTransition

class MenuViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    let bubbleTransition = BubbleTransition()
    @IBOutlet weak var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.isEnabled = false
        nameLabel.isHidden = true
        
        loginButton.isEnabled = false
        loginButton.isHidden = true
        if User.current.exists { // logged in
            nameLabel.isEnabled = true
            nameLabel.isHidden = false
            
            if User.current.name != nil {
                self.nameLabel.text = User.current.name
            }
            
            loginButton.isEnabled = false
            loginButton.isHidden = true
        } else {
            nameLabel.isEnabled = false
            nameLabel.isHidden = true
            
            loginButton.isEnabled = true
            loginButton.isHidden = false
        }
    }
    
    @IBAction func menuButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
        self.present(viewController, animated: true, completion: nil)
    }
 
    /* 
 Add code to get the user data
 Add IBOutlets to put the data on the screen
 ...
 */
 
}
