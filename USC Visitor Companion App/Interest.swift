//
//  Interest.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/28/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class Interest: NSObject {

    // MARK: Parse object
    private let object: PFObject?
    
    // MARK: Interest Properties
    var objectId: String?
    
    var name: String?
    
    var locations: [Location]?
    
    // construct single localized Interest object
    init(object: PFObject) {
        
        // set the object and
        self.object = object
        self.name = object["name"] as! String?
        self.objectId = object.objectId
        locations = [Location]()
        if let locationNames = object["locations"] as! [String]? {
            
            for locName in locationNames {
                if let locObject = LocationData.shared.namesToLocations[locName] {
                    self.locations?.append(locObject)
                }
            }
        } else {
            print("ERROR: could not acquire location names")
        }
        
//        var locs = [String]()
//        for locationName in LocationData.shared.namesToLocations.keys {
//            locs.append(locationName)
//        }
//        
//        self.object?["locations"] = locs
//        self.object?.saveInBackground()

    }
    
//    private func update(value: Any?, forKey key: String) {
//        self.object?[key] = value
//        self.object?.saveInBackground()
//    }
    
    
    
    // DO NOT CALL. for use by Data models. remove Location from "this" Interest
    func untagLocation(locationName: String) -> () {
        // arrays to store updated data
        var locArr = [Location]()
        var locNames = [String]()
        
        // for each Location object associated with this Interest
        for locObject in self.locations! {
            
            // if the object isn't the one we're trying to remove
            if locObject.name != locationName {
                // add the object and its name to the appropriate new arrays
                locArr.append(locObject)
                locNames.append(locObject.name!)
            }
        }
        
        // assign the newly created Location array to the Interest object
        self.locations = locArr
        
        // save the newly created String array to the interest object on the server
        self.object?["locations"] = locNames
        self.object?.saveInBackground()
    }
    
    // DO NOT CALL. for use by Data models
    func tagLocation(locationName: String) -> () {
        
        if let location = LocationData.shared.getLocation(withName: locationName) {
        
            if self.locations?.index(of: location) == nil {
                self.locations?.append(location)
                
                
                var locNames = [String]()
                
                for locObject in self.locations! {
                    locNames.append(locObject.name!)
                }
                
                self.object?["locations"] = locNames
                self.object?.saveInBackground()
            }
        }
    }
    
    // DO NOT CALL. for use by Data models. Updates the location name on the database (the local object's name is changed in LocationData)
    func renameLocation(oldName: String, newName: String) {
       
        var locNames = [String]()
        
        // for each Location object associated with this Interest
        for locObject in self.locations! {
            
            // if the object isn't the one we're trying to remove
            if locObject.name != oldName {
                // add the location name to the new array
                locNames.append(locObject.name!)
            }
        }
        
        // add the new name to the array
        locNames.append(newName)
        
        // save the newly created String array to the interest object on the server
        self.object?["locations"] = locNames
        self.object?.saveInBackground()
    }
    
    // DO NOT CALL. for use by Data models. deletes this location from everything. intended to be called from deleteInterests via InterestsData.shared
    func delete() {
        for location in self.locations! {
            var names = [String]()
            names.append(self.name!)
            location.removeInterestTags(interestNames: names)
        }
        // delete from database
        self.object?.deleteInBackground()
        
        // delete locally
        InterestsData.shared.namesToInterests[self.name!] = nil;
        
    }
}
