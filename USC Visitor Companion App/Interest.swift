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
    
    // construct single localized Interest object
    init(object: PFObject) {
        
        self.name = object["name"] as! String?
        self.objectId = object.objectId
        if let objects = object["locations"] as! [PFObject]? {
            // if the database grows, we may want to parse a few coordinated maps in LocationData to make these lookups constant time instead of n^2
            for obj in objects {
                
                // if we find a name for this object ID
                if let name = LocationData.shared.idsToNames[obj.objectId!] {
                    if let location = LocationData.shared.namesToLocations[name] {
                        self.locations?.append(location)
                    }
                }
            }
            print(objects)
        }
        
        
       
//        for loc in objects {
//            //let location = Location(object: loc)
//            print(loc)
//            // Hey LocationData, give me the associated Location object
//            
//            //locations?.append(location)
//        }
        
    }
}
