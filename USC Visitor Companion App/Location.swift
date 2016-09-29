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
    var object: PFObject! {
        didSet {
            self.objectId = self.object.value(forKey: "objectId") as? String
            self.name = self.object.value(forKey: "name") as? String
            self.code = self.object.value(forKey: "code") as? String
            self.details = self.object.value(forKey: "details") as? String
            self.coordinate = self.object.value(forKey: "coordinate") as? CLLocation
            self.interests = self.object.value(forKey: "interests") as? [String]
        }
    }
    
    
    // MARK: Location Properties
    var objectId: String?

    var name: String?
    
    var code: String?
    
    var details: String?
    
    var coordinate: CLLocation?
    
    var interests: [String]?
    
    
    // MARK: Constructor
    init(object: PFObject) {
        super.init()
        self.object = object
    }
    
}
