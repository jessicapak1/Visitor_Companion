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
    var current_location : Location?

    override func viewDidLoad() {
        super.viewDidLoad()
        if name == nil {
            locationName.text = "Check-in is temporarily unavailable"
        }
        else {
            locationName.text = name
        }
        
        findLocationObject()
        loadLocationData()
        
    }
    
    func findLocationObject() {
        for location in LocationData.shared.locations {
            if location.name == name {
                current_location = location
                break
            }
        }
    }
    
    func loadLocationData(){
        // start loading fields with location data
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
