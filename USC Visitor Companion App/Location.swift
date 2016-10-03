//
//  Location.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class Location: NSObject {
    
    // MARK: Properties
    var objectId: String?

    var name: String?
    
    var code: String?
    
    var details: String?
    
    var location: CLLocation?
    
    var interests: [String]?
    
    
    // MARK: Constructor
    init(object: PFObject) {
        self.objectId = object.objectId
        self.name = object["name"] as! String?
        self.code = object["code"] as! String?
        self.details = object["details"] as! String?
        let coordinate = object["location"] as! PFGeoPoint?
        self.location = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
        self.interests = object["interests"] as! [String]?
    }
    
}
