//
//  InterestsData.swift
//  USC Visitor Companion App
//
//  Created by Jeffrey Vaudrin-McLean on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

//import Foundation
import Parse

class InterestsData : NSObject {
    
    private var namesToInterests = [String: Interest]()
    
    private static var interestsData = InterestsData()
    
    // declare map => string(names) to Interest --> Interest holds [Interest]
    
    
    override init() {
        // call super?
        super.init()
        
        var query = PFQuery(className: "Interest")
        query.order(byAscending: "name")
        
        do {
            let interestObjects = try query.findObjects()
            for iObject in interestObjects {
                let interestObject = Interest(object: iObject);
                namesToInterests[interestObject.name!] = interestObject
            }
            
        } catch {
            print("did not build InterestData successfully")
        }
    }
    
    // returns an array of all names of interets in database
    func getInterestNames(name: String) -> [String] {
        var names = [String]()
        for name in namesToInterests.keys {
            names.append(name)
        }
        return names
    }
    
    
    
}

/*
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
 */
