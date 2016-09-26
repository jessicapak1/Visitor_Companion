//
//  MapViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinates 34.020496, 118.285317 at zoom level 17 (shows building outlines)
        let camera = GMSCameraPosition.camera(withLatitude: 34.020496, longitude: -118.285317, zoom: 20.0)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view.insertSubview(mapView, at: 0)
        
        // query from parse for locations and create markers for each location on map
        let query = PFQuery(className:"Location")
        query.limit = 1000
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) locations.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let marker = GMSMarker()
                        let geopoint = object["coordinate"] as! PFGeoPoint
                        marker.position = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude)
                        marker.title = object["name"] as! String?
                        marker.snippet = object["description"] as! String?
                        marker.map = mapView
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        logOutAction();
    }

//    @IBAction func optionsButtonPressed(_ sender: AnyObject) {
//        let view = OptionsView.instanceFromNib()
//        self.view.addSubview(view)
//    }
    
    func logOutAction(){
        let currentUser = PFUser.current()
        if currentUser != nil {
            // Do stuff with the user
            PFUser.logOut()
            let alert = UIAlertView(title: "Success", message: "Logged Out", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            self.present(viewController, animated: true, completion: nil)
        } else {
            // Show the signup or login screen
            let alert = UIAlertView(title: "Error", message: "No user to logout", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        // Send a request to log out a user
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
