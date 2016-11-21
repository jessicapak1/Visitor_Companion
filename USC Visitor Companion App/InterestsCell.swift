//
//  InterestsCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import FacebookShare
import MapKit

class InterestsCell: UITableViewCell {

    @IBOutlet weak var backgroundBlurView: UIVisualEffectView!
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var checkinButton: UIButton!
    
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var closeProximity : Bool!
    var current : Location!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myBackgroundView.layer.cornerRadius = 15
        myBackgroundView.layer.masksToBounds = true
        backgroundBlurView.layer.cornerRadius = 15
        backgroundBlurView.layer.masksToBounds = true

    }
    
    func setCurrentLocation(currentLocation: Location, isClose: Bool) {
        self.current = currentLocation
        self.closeProximity = isClose
    }

    @IBAction func checkinButtonPressed(_ sender: Any) {
        print("checkin button pressed")
    }
    
    @IBAction func directionsButtonPressed(_ sender: Any) {
        openMapWithDirections(location: (current?.location)!, name: (current?.name!)!)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let content = LinkShareContent(url: URL(string: "http://viterbi.usc.edu")!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .web
        shareDialog.failsOnInvalidData = true
        shareDialog.completion =  {
            result in
            print("Shared to Facebook")
        }
        try? shareDialog.show()
    }
    
    func openMapWithDirections(location: CLLocation, name: String){
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}
