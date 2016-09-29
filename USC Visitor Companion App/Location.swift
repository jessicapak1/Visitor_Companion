//
//  Location.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class Location: NSObject {
    
    // MARK: Location Properties
    var name: String? {
        get { return self.value(forKey: "name") }
        set { self.setValue(newValue, forKey: "name") }
    }
    
    var code: String? {
        get { return self.value(forKey: "code") }
        set { self.setValue(newValue, forKey: "code") }
    }
    
    var details: String? {
        get { return self.value(forKey: "details") }
        set { self.setValue(newValue, forKey: "details") }
    }
    
    var coordinate: CLLocation? {
        get { return self.value(forKey: "coordinate") }
        set { self.setValue(newValue, forKey: "coordinate") }
    }
    
    var interests: [String]? {
        get { return self.value(forKey: "interests") }
        set { self.setValue(newValue, forKey: "interests") }
    }
    
    
    // MARK: Constructor
    init(object: PFObject) {
        super.init()
        self.name = object.value(forKey: "name") as? String
        self.code = object.value(forKey: "code") as? String
        self.details = object.value(forKey: "details") as? String
        self.coordinate = object.value(forKey: "coordinate") as? CLLocation
        self.interests = object.value(forKey: "interests") as? [String]
    }
    
    
    // MARK: Location Methods
    

    // MARK: Private Methods
    private func value(forKey key: String) -> String? {
        if let currentUser = PFUser.current() {
            return currentUser.value(forKey: key) as? String
        }
        return nil
    }
    
    private func value(forKey key: String) -> CLLocation? {
        if let currentUser = PFUser.current() {
            return currentUser.value(forKey: key) as? CLLocation
        }
        return nil
    }
    
    private func value(forKey key: String) -> [String]? {
        if let currentUser = PFUser.current() {
            return currentUser.value(forKey: key) as? [String]
        }
        return nil
    }
    
    private func setValue(value: Any?, forKey key: String) {
        if let currentUser = PFUser.current() {
            currentUser.setValue(value, forKey: key)
        }
    }
    
}
