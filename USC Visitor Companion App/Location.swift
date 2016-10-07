//
//  Location.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class Location: NSObject {
    
    // MARK: Object
    private var object: PFObject?
    
    
    // MARK: Properties
    var objectId: String? // should never be set

    var name: String? { willSet { self.update(value: newValue, forKey: "name") } }
    
    var code: String? { willSet { self.update(value: newValue, forKey: "code") } }
    
    var details: String? { willSet { self.update(value: newValue, forKey: "details") } }
    
    var location: CLLocation? { willSet { self.update(value: newValue, forKey: "location") } }
    
    var interests: [String]? { willSet { self.update(value: newValue, forKey: "interests") } }
    
    
    // MARK: Constructor
    init(object: PFObject) {
        self.object = object
        self.objectId = object.objectId
        self.name = object["name"] as! String?
        self.code = object["code"] as! String?
        self.details = object["details"] as! String?
        let coordinate = object["location"] as! PFGeoPoint?
        self.location = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
        self.interests = object["interests"] as! [String]?
    }
    
    
    // MARK: Private Methods
    private func update(value: Any?, forKey key: String) {
        object?[key] = value
        object?.saveInBackground()
    }
    
}
