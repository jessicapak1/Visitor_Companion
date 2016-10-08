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

    @IBOutlet weak var addButtonOutlet: UIBarButtonItem!
    var locations: [Location] = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addButtonOutlet.isEnabled = false;
        let currentUser = PFUser.current()
        
        if currentUser != nil {
            // if is admin then enable add button
            let isAdmin = currentUser?["isAdmin"] as! Bool
            if(isAdmin == true)
            {
                addButtonOutlet.isEnabled = true;
            }
        } else
        {
            // Show the signup or login screen
        }
        
        
        //get all locations from wrapper class
        locations = LocationData.shared.locations
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var addButtonAction: UIBarButtonItem!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
