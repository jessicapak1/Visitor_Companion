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
    
    let bubbleTransition = BubbleTransition()
    @IBOutlet weak var menuButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var interestsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = User.current.name
        emailLabel.text = User.current.email
        interestsLabel.text = User.current.interest
    }
    
    @IBAction func menuButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    
    /* 
 Add code to get the user data
 Add IBOutlets to put the data on the screen
 ...
 */
 
}
