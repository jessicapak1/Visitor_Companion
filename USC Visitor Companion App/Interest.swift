//
//  Interest.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/28/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class Interest: NSObject {

    // MARK: Interest Properties
    var objectId: String?
    
    var name: String?
    
    var locations: [Location]?
    
    init(object: PFObject) {
        
        self.name = object["name"] as? String
        self.objectId = object.objectId!
        
        for loc in object["locations"] as? PFObject {
            let location = Location(object: loc)
            
            locations?.append(location)
        }
        
    }
    
    class func create(name: String) {
        
        let object = PFObject(className:"Interest")
        object["name"] = name
        
        //var locations = [Location]()
        
//        var loc1 = Location.create(name: "fakeName", code: "fakeCode", details: "fakeDetails", location: nil, interests: nil, callback: nil)
//        
//        locations.append(loc1)
//        object["locations"] = locations
        
        object.saveInBackground()
        
    }
    
}
