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
    
    // returns an array of strings as names of all interests in database
    func interestNames() -> [String] {
        var names = [String]()
        for name in namesToInterests.keys {
            names.append(name)
        }
        return names
    }
    
    // returns true if name is an existing Interest, false otherwise
    func interest(withName name: String) -> Interest {
        return self.namesToInterests[name]!
    }
    
    // returns array strings as names of all interests with names that either begin with or contain the 'keyword'
    func interestNames(withKeyword keyword: String) -> [String] {
        var matches = [String]()
        
        // for all interest names held in this singletons map
        for interestName in self.namesToInterests.keys {
            
            // if the keyword is a prefix of an interest name
            if interestName.lowercased().hasPrefix(keyword.lowercased()) {
                matches.append(interestName)
            // if the keyword is contained
            } else if interestName.lowercased().contains(keyword.lowercased()) && keyword.characters.count >= 3 {
                matches.append(interestName)
            }
        }
        return matches
    }
    
    func deleteInterest(withName interestName: String) -> () {
        
        // if we find this interest name in our backend (which we should)
        if let localInterest = self.namesToInterests[interestName] {
            do {
                var locationIDs = [String]()
                
                // loop through
                for location in localInterest.locations! {
                    
                    // save object IDs
                    locationIDs.append(location.objectId!)
                    // delete interest from locations locally
                    /* requires new method in LocationData */
                    
                }
                
                // interest from locations within database
                let locQuery = PFQuery(className: "Location")
                locQuery.whereKey("objectId", containedIn: locationIDs)
                var locationsPFObject = try locQuery.findObjects()
                
                for locationOB in locationsPFObject {
                    // NOTE: this line is suspect, lets see if we can find a way from fetch all of these or doing this all in the background
                    let interestsWithoutCurrent = locationOB.fetchInBackground()
                }
                
                
                
                // create a query for the Interest object from the database
                let intQuery = PFQuery(className: "Interest")
                intQuery.whereKey("name", equalTo: interestName)
                let interestPFObject = try intQuery.getFirstObject()
                // delete interest from database
                interestPFObject.deleteInBackground()
                
                // delete interest from namesToInterests
                self.namesToInterests.removeValue(forKey: interestName)
            } catch {
                print("An error occurred trying to delete Interest from database")
            }
            
        }
        
        
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
