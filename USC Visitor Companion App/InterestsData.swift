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
    
    
    
    static let shared: InterestsData = InterestsData()
    
    // declare map => string(names) to Interest --> Interest holds [Interest]
    var namesToInterests: [String: Interest] = [String: Interest]()
    
    override init() {
        // call super?
        //super.init()
        
        let query = PFQuery(className: "Interest")
        query.order(byAscending: "name")
        
        do {
            let interestObjects = try query.findObjects()
            for iObject in interestObjects {
                let interestObject = Interest(object: iObject);
                self.namesToInterests[interestObject.name!] = interestObject
            }
            
        } catch {
            print("did not build InterestData successfully")
        }
    }
    
    func create(name: String) {
        
        let object = PFObject(className:"Interest")
        object["name"] = name
        
        //var locations = [Location]()
        
        //        var loc1 = Location.create(name: "fakeName", code: "fakeCode", details: "fakeDetails", location: nil, interests: nil, callback: nil)
        //
        //        locations.append(loc1)
        //        object["locations"] = locations
        
        object.saveInBackground()
        
    }
    
    // returns an array of all names of interets in database
    func getInterestNames(name: String) -> [String] {
        var names = [String]()
        for name in namesToInterests.keys {
            names.append(name)
        }
        return names
    }
    
    func getInterestNames(withPrefix prefix: String) -> [String] {
        var matches = [String]()
        
        for interestName in self.namesToInterests.keys {
            
            let lowercaseMatches = interestName.lowercased().hasPrefix(prefix.lowercased())
            
            if lowercaseMatches {
                matches.append(interestName)
            }
        }
        return matches
    }
//    func interests(withPrefix prefix: String) -> [String] {
//        var nameMatches = [String]()
//        for interestName in self.namesToInterests.keys {
//            let lowercaseNameMatches = interestName.uppercased().hasPrefix(prefix.uppercased())
//            let uppercaseNameMatches = interestName.lowercased().hasPrefix(prefix.lowercased())
//            if lowercaseNameMatches || uppercaseNameMatches {
//                nameMatches.append(interestName)
//            }
//        }
//        return nameMatches
//    }

    
    
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
