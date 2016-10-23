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
    
    func removeInterestTag(interestName: String) {
        
        var interestNameArr = self.object?["interests"] as! [String]
        if let serverIndex = interestNameArr.index(of: interestName) {
            interestNameArr.remove(at: serverIndex)
            self.object?.setObject(interestName, forKey: "interests")
            self.object?.saveInBackground()
            
            let localIndex = self.interests?.index(of: interestName)
            self.interests?.remove(at: localIndex!)
        } else {
            print("ERROR: something went wrong removing and interest from a location")
        }
        
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
