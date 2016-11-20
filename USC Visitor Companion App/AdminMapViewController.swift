//
//  AdminMapViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 11/19/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse

protocol MapViewDelegates {
    func userDidSaveMap(newLocation: CLLocation)
}

class AdminMapViewController: UIViewController, GMSMapViewDelegate {
    var mapDelegate: MapViewDelegates?
    var mapView : GMSMapView!
    var newLocation: CLLocation? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 34.02114,
                                              longitude:-118.286031, zoom:15.35)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        
        self.mapView?.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.view = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let delegate = self.mapDelegate {
            delegate.userDidSaveMap(newLocation: newLocation!)
         
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = "Add Location"
        marker.map = self.mapView
        
        let location: CLLocation =  CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
        newLocation = location
        
    }
}
