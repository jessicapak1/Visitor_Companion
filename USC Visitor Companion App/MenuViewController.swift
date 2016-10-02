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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func menuButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
