//
//  AdminSegmentedViewControoler.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/9/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class AdminSegmentedViewControoler: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var interetsLocationsSegementedControl: UISegmentedControl!
    
    @IBOutlet weak var interestsLocationsTableView: UITableView!
    
    var interests: [String] = [String]()
    var locations: [Location] = [Location]()
    var locationName : String = ""
    var location: Location? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get all locations from wrapper class
        locations = LocationData.shared.locations
        interests = InterestsData.shared.interestNames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlChanged(_ sender: AnyObject) {
        
        interestsLocationsTableView.reloadData()
    }

    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        switch interetsLocationsSegementedControl.selectedSegmentIndex {
        case 0:
            returnValue = interests.count
            break
        case 1:
            returnValue = locations.count
            break
        default:
            break
        }
        return returnValue
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch interetsLocationsSegementedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = interests[indexPath.row]
            break
        case 1:
            cell.textLabel?.text = locations[indexPath.row].name
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.
        if interetsLocationsSegementedControl.selectedSegmentIndex == 1 {
            let row = indexPath.row
            location = locations[row]
            locationName = (location?.name!)!
            
            self.performSegue(withIdentifier: "edit_location", sender: nil)
            /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navViewController = storyboard.instantiateViewController(withIdentifier: "admin_one") as! UINavigationController
            
            let adminVC = navViewController.viewControllers.first as! AdminTableViewController
            adminVC.locationName = locationName;
            self.present(adminVC, animated: true, completion: nil)*/
        } else {
            print("interest segment")
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        switch interetsLocationsSegementedControl.selectedSegmentIndex {
        case 0:
            //update the correct table and data source!
            if editingStyle == UITableViewCellEditingStyle.delete {
                //delete from database
                print(interests[indexPath.row])
                InterestsData.shared.deleteInterest(withName: interests[indexPath.row])
                //delete from local source array
                interests.remove(at: indexPath.row)
                //delete from view
                interestsLocationsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            } else if editingStyle ==  UITableViewCellEditingStyle.insert {

            }
            
            break
        case 1:
            //update the correct table and data source!
            if editingStyle == UITableViewCellEditingStyle.delete {
                //delete from database
                LocationData.shared.deleteLocation(withName: locations[indexPath.row].name!)
                //delete from local source array
                locations.remove(at: indexPath.row)
                //delete from view
                interestsLocationsTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            } else if editingStyle ==  UITableViewCellEditingStyle.insert {
                //update database here, or not really? will only do it with the new admin view
            }
            break
        default:
            break
        }

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "edit_location") {
                //get a reference to the destination view controller
            let navViewController = segue.destination as! UINavigationController
            let adminVC = navViewController.viewControllers.first as! AdminTableViewController
            adminVC.locationName = locationName;
        }
    }
 

}
