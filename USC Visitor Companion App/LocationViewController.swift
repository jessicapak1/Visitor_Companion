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
        
        findLocationObject()
        loadLocationData()
        
    }
    
    func findLocationObject() {
        current_location = LocationData.shared.getLocation(withName: name!)
        
    }
    
    func loadLocationData(){
        // start loading fields with location data
        locationName.text = current_location?.name
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
