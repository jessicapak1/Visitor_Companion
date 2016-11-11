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
        super.init()
        self.fetchInterests()
    }
    
    func fetchInterests() {
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
    
    func create(name: String, callback: @escaping (Bool) -> Void) {
        
        let object = PFObject(className:"Interest")
        object["name"] = name
        object["locations"] = [String]()
      
        object.saveInBackground(block: {
            (succeeded, error) -> Void in
            if succeeded {
                let interest = Interest(object: object)
                self.namesToInterests[name] = interest
            }
            callback(succeeded)
        })

        
        
    }
    
    // returns an array of strings as names of all interests in database
    func interestNames() -> [String] {
        var names = [String]()
        for name in namesToInterests.keys {
            names.append(name)
        }
        return names
    }
    
    // returns Interest with name if it exists, otherwise nil
    func interest(withName name: String) -> Interest? {
        let interest = self.namesToInterests[name]
        if let interest = interest {
            return interest
        }
        return nil
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
    
    // call to remove location from all interests
    func removeLocation(withLocation location: Location) -> () {
        for interestName in location.interests! {
            self.namesToInterests[interestName]?.untagLocation(locationName: location.name!)
        }
    }
    
    // call to completely delete an interest
    func deleteInterest(withName interestName: String) -> () {
        if let interestForDelete = self.namesToInterests[interestName] {
            interestForDelete.delete()
        }
    }
    
    
    
//    func deleteInterest(withName interestName: String) -> () {
//        
//        // if we find this interest name in our backend (which we should)
//        if let localInterest = self.namesToInterests[interestName] {
//            do {
//                var locationIDs = [String]()
//                
//                
//                if let localInterestLocations = localInterest.locations {
//                    // loop through
//                    for location in localInterestLocations {
//                        
//                        // save object IDs in order to change database
//                        locationIDs.append(location.objectId!)
//                        
//                        // delete interest from Locations locally
//                        location.interests = location.interests?.filter{$0 != interestName}
//                    }
//                }
//                
//                
//                // interest from locations within database
//                let locQuery = PFQuery(className: "Location")
//                locQuery.whereKey("objectId", containedIn: locationIDs)
//                let locationsPFObject = try locQuery.findObjects()
//                
//                for locationOB in locationsPFObject {
//                    
//                    // get the updated locations list from our local data in LocationData
//                    let locName = LocationData.shared.idsToNames[locationOB.objectId!]
//                    let interestsWithoutDeleted = LocationData.shared.namesToLocations[locName!]?.interests
//                    
//                    // set the value of the interests array in the parse object to be the new array without the deleted intest
//                    locationOB.setObject(interestsWithoutDeleted, forKey: "interests")//.set("interests", interestsWithoutCurrent)
//                    
//                    // save the parse object to the database
//                    locationOB.saveInBackground()
//                }
//                
//                
//                // create a query for the Interest object from the database
//                let intQuery = PFQuery(className: "Interest")
//                intQuery.whereKey("name", equalTo: interestName)
//                let interestPFObject = try intQuery.getFirstObject()
//                
//                // delete interest from database
//                interestPFObject.deleteInBackground()
//                
//                // delete interest from namesToInterests
//                self.namesToInterests.removeValue(forKey: interestName)
//            } catch {
//                print("An error occurred trying to delete Interest from database")
//            }
//        }
//    }
    
    
    
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
