//
//  User.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    // MARK: Properties
    var name: String { willSet { self.update(value: newValue, forKey: "name") } }
    
    var username: String { willSet { self.update(value: newValue, forKey: "username") } }
    
    var email: String { willSet { self.update(value: newValue, forKey: "email") } }
    
    var interest: String { willSet { self.update(value: newValue, forKey: "interest") } }
    
    var type: String { willSet { self.update(value: newValue, forKey: "type") } }
    
    
    // MARK: Constructor
    init(user: PFUser) {
        self.name = user["name"] as! String
        self.username = user["username"] as! String // might need to use object.username
        self.email = user["email"] as! String
        self.interest = user["interest"] as! String
        self.type = user["type"] as! String
    }
    
    
    // MARK: Class Methods
    class func current() -> User? {
        if let user = PFUser.current() {
            return User(user: user)
        }
        return nil
    }
    
    class func signup(name: String, username: String, password: String, email: String, type: String, callback: @escaping (Bool) -> Void) {
        let user = PFUser()
        user["name"] = name
        user["username"] = username // might need to use user.username
        user["password"] = password
        user["email"] = email
        user["interest"] = "General" // change to default interest
        user["type"] = type
        user.signUpInBackground(block: {
            (succeeded, error) -> Void in
            callback(succeeded)
        })
    }
    
    class func login(username: String, password: String, callback: @escaping (Bool) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password, block: {
            (user, error) -> Void in
            callback(error == nil)
        })
    }
    
    class func logout() {
        PFUser.logOut()
    }
    
    class func locationsNearby(completionHandler: @escaping ([Location]) -> Void) {
        PFGeoPoint.geoPointForCurrentLocation(inBackground: {
            (userGeoPoint, error) in
            if let userGeoPoint = userGeoPoint {
                print("user location success")
                let locationQuery = PFQuery(className: "Location")
                locationQuery.whereKey("coordinate", nearGeoPoint: userGeoPoint)
                locationQuery.limit = 10
                do {
                    let objects = try locationQuery.findObjects()
                    print("locations nearby success")
                    var locations = [Location]()
                    for object in objects {
                        let location = Location(object: object)
                        locations.append(location)
                    }
                    completionHandler(locations)
                } catch {
                    print("locations nearby error")
                }
            } else {
                print("user location error")
            }
        })
    }
    
    
    // MARK: Private Methods
    private func update(value: String, forKey key: String) {
        if let object = PFUser.current() {
            object[key] = value
            object.saveInBackground()
        }
    }
    
}
