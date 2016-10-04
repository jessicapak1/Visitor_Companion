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
import BubbleTransition

class MapViewController: UIViewController, GMSMapViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate {
    
    // MARK:
    let bubbleTransition = BubbleTransition()
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinates 34.020496, 118.285317 at zoom level 17 (shows building outlines)
        let camera = GMSCameraPosition.camera(withLatitude: 34.020496, longitude: -118.285317, zoom: 20.0)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
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
                        if let geopoint = object["location"] as? PFGeoPoint {
                            marker.position = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude)
                            marker.title = object["name"] as! String?
                            marker.snippet = object["details"] as! String?
                            marker.map = mapView
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let locations = LocationData.shared.locations(withPrefix: self.searchBar.text!)
        for location in locations {
            print(location.name!, location.code!)
        }
        print("-----------------------------------------------")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let locations = LocationData.shared.locations(withPrefix: searchText)
        for location in locations {
            print(location.name!, location.code!)
        }
        print("-----------------------------------------------")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            self.performSegue(withIdentifier: "CheckInScreenSegue", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Menu" {
            let MVC = segue.destination as! MenuViewController
            MVC.transitioningDelegate = self
            MVC.modalPresentationStyle = .custom
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .present
        self.bubbleTransition.startingPoint = self.menuButton.center
        self.bubbleTransition.bubbleColor = UIColor.init(white: 0.9, alpha: 0.8)
        return self.bubbleTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .dismiss
        self.bubbleTransition.startingPoint = self.menuButton.center
        self.bubbleTransition.bubbleColor = UIColor.blue
        return self.bubbleTransition
    }

    func logOutAction(){
        let currentUser = PFUser.current()
        if currentUser != nil {
            // Do stuff with the user
            PFUser.logOut()
            let alertController = UIAlertController(title: "Sucess", message: "Logged Out!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
                
            }
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login")
            self.present(viewController, animated: true, completion: nil)
        } else {
            // Show the signup or login screen
            let alertController = UIAlertController(title: "Error", message: "No User To Logout", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {
            }
        }
        // Send a request to log out a user
        
        
        
    }

}
