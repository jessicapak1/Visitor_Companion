//
//  LocationViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    

    @IBOutlet weak var locationName: UITextView!
    
    var name : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if (name == nil)
        {
            locationName.text = "Check-in ain't working, man"
        }
        else {
            locationName.text = name
        }
        
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
