//
//  LocationsViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class LocationsViewController: UITableViewController {

    @IBOutlet weak var addButtonOutlet: UIBarButtonItem! {
        didSet {
            addButtonOutlet.isEnabled = false
        }
    }
    
    
    var locations: [Location] = LocationData.shared.locations
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.current.type == .admin {
            addButtonOutlet.isEnabled = true
        } else {
            // Show the signup or login screen
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var addButtonAction: UIBarButtonItem!
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.item].name
        cell.detailTextLabel?.text = locations[indexPath.item].details
        return cell
    }
    
}
