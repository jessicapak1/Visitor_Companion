//
//  LocationData.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class LocationData: NSObject {
    
    // MARK: Shared Location Data
    static let shared: LocationData = LocationData()
    
    
    // MARK: Properties
    var locations: [Location] = [Location]()
    
    var idsToNames: [String: String] = [String: String]()
    
    var namesToLocations: [String: Location] = [String: Location]()
    
    
    // MARK: Constructor
    override init() {
        let query = PFQuery(className: "Location")
        query.order(byAscending: "name")
        do {
            let objects = try query.findObjects()
            for object in objects {
                let location = Location(object: object)
                self.locations.append(location)
            }
            for location in self.locations {
                if let name = location.name {
                    self.namesToLocations[name] = location
                    if let id = location.objectId {
                        self.idsToNames[id] = name
                    }
                }
            }
        } catch {
            
        }
    }

    
    // MARK: Instance Methods
    func create(name: String, code: String, details: String, location: CLLocation, interests: [String], callback: @escaping (Bool) -> Void) {
        let object = PFObject(className: "Location")
        object["name"] = name
        object["code"] = code
        object["details"] = details
        object["location"] = location
        object["interests"] = interests
        object.saveInBackground(block: {
            (succeeded, error) -> Void in
            if succeeded {
                let location = Location(object: object)
                self.locations.append(location)
                if let name = location.name {
                    self.namesToLocations[name] = location
                    if let id = location.objectId {
                        self.idsToNames[id] = name
                    }
                }
            }
            callback(succeeded)
        })
    }
    
    func locations(withPrefix prefix: String) -> [Location] {
        var nameMatches = [Location]()
        var codeMatches = [Location]()
        for location in self.locations {
            let lowercaseNameMatches = (location.name?.uppercased().hasPrefix(prefix.uppercased()))!
            let uppercaseNameMatches = (location.name?.lowercased().hasPrefix(prefix.lowercased()))!
            let lowercaseCodeMatches = (location.code?.uppercased().hasPrefix(prefix.uppercased()))!
            let uppercaseCodeMatches = (location.code?.lowercased().hasPrefix(prefix.lowercased()))!
            if lowercaseNameMatches || uppercaseNameMatches {
                nameMatches.append(location)
            } else if lowercaseCodeMatches || uppercaseCodeMatches {
                codeMatches.append(location)
            }
        }
        return nameMatches + codeMatches
    }
}
