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
    
    // MARK: Location Object
    private var object: PFObject?
    
    
    // MARK: Location Properties
    var objectId: String?

    var name: String?
    
    var code: String?
    
    var details: String?
    
    var location: CLLocation?
    
    var interests: [Interest]?
    
    
    // MARK: Constructor
    init(object: PFObject) {
        super.init()
        self.object = object
        self.objectId = object.objectId
        self.name = object["name"] as! String?
        self.code = object["code"] as! String?
        self.details = object["details"] as! String?
        let coordinate = object["location"] as! PFGeoPoint?
        self.location = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
        self.interests = object["interests"] as! [Interest]?
    }
    
}
