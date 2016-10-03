//
//  LocationData.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class LocationData: NSObject {
    
    // MARK: Locations
    static var locations: [Location] {
        let query = PFQuery(className: "Location")
        query.order(byAscending: "name")
        var locations = [Location]()
        do {
            let objects = try query.findObjects()
            for object in objects {
                let location = Location(object: object)
                locations.append(location)
            }
        } catch {
            
        }
        return locations
    }
    
    
    
}
