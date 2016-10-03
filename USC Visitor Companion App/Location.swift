//
//  Location.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class Location: NSObject {
    
    // MARK: Properties
    var objectId: String

    var name: String
    
    var code: String
    
    var details: String
    
    var location: CLLocation
    
    var interests: [Interest]
    
    
    // MARK: Constructor
    init(object: PFObject) {
        self.objectId = object.objectId!
        self.name = object["name"] as! String
        self.code = object["code"] as! String
        self.details = object["details"] as! String
        let coordinate = object["location"] as! PFGeoPoint
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.interests = object["interests"] as! [Interest]
    }
    
    
    // MARK: Class Methods
    class func create(name: String, code: String, details: String, location: CLLocation, interests: [String], callback: @escaping (Bool) -> Void) {
        let object = PFObject(className: "Location")
        object["name"] = name
        object["code"] = code
        object["details"] = details
        object["location"] = location // might need to use PFGeoPoint(location: location)
        object["interests"] = interests
        object.saveInBackground(block: {
            (succeeded, error) -> Void in
            if succeeded {
                //let location = Location(object: object)
                // add location to locations array
                // check if objectId is set
            }
            callback(succeeded)
        })
    }
    
}
