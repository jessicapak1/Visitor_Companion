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
    
    var locType: String? { willSet {self.update(value: newValue, forKey: "locType") } }
    
    
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
        self.locType = object["locType"] as! String?
    }
    
    
    // MARK: Private Methods
    private func update(value: Any?, forKey key: String) {
        object?[key] = value
        object?.saveInBackground()
    }
    
    func removeInterestTags(interestNames: [String]) {
        
        var interestNameArr = self.object?["interests"] as! [String]
        for interestName in interestNames {
            if let serverIndex = interestNameArr.index(of: interestName) {
                interestNameArr.remove(at: serverIndex)
                self.object?.setObject(interestNameArr, forKey: "interests")
                
                let localIndex = self.interests?.index(of: interestName)
                self.interests?.remove(at: localIndex!)
            } else {
                print("ERROR: something went wrong removing an interest from a location")
            }
        }
        
        self.object?.saveInBackground()
        
    }
    
    // DO NOT CALL THIS FUNCTION. Only for use by LocationData
    func addInterestTags(interestNames: [String]) {
        
        for interestName in interestNames {
            if self.interests?.index(of: interestName) == nil {
                self.interests?.append(interestName)
            }
        }
        
        self.object?["interests"] = self.interests
        self.object?.saveInBackground()
        
        
    }
    
    func changeDetails(newDetails: String) {
        self.details = newDetails
        
        self.object?["details"] = newDetails
        self.object?.saveInBackground()
    }
    
    func delete() {
        InterestsData.shared.removeLocation(withLocation: self)
        
        self.object?.deleteInBackground()
        
        LocationData.shared.idsToNames[self.objectId!] = nil
        
        LocationData.shared.namesToLocations[self.name!] = nil
    }
    
//    func getPFObject() -> PFObject {
//        return object!;
//    }
    
}
