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
    
    // MARK: Current
    static let current: User = User()
    
    
    // MARK: Properties
    var active: Bool {
        get { return PFUser.current() != nil }
    }
    
    var name: String? {
        willSet {
            PFUser.current()?["name"] = newValue!
            PFUser.current()?.saveInBackground()
        }
    }
    
    var username: String? {
        willSet {
            PFUser.current()?["username"] = newValue!
            PFUser.current()?.saveInBackground()
        }
    }
    
    var email: String? {
        willSet {
            PFUser.current()?["email"] = newValue!
            PFUser.current()?.saveInBackground()
        }
    }
    
    var interest: String? {
        willSet {
            PFUser.current()?["interest"] = newValue!
            PFUser.current()?.saveInBackground()
        }
    }
    
    var type: String? {
        willSet {
            PFUser.current()?["type"] = newValue!
            PFUser.current()?.saveInBackground()
        }
    }

    
    // MARK: Class Methods
    class func signup(username: String, password: String, email: String) {
        let user = PFUser()
        user.setValue(username, forKey: "username")
        user.setValue(password, forKey: "password")
        user.setValue(email, forKey: "email")
        do {
            try user.signUp()
            User.current.setProperties()
            print("signup success")
        } catch {
            print("signup error")
        }
    }
    
    class func login(username: String, password: String) {
        do {
            try PFUser.logIn(withUsername: username, password: password)
            User.current.setProperties()
            print("login success")
        } catch {
            print("login error")
        }
    }
    
    class func logout() {
        PFUser.logOut()
        User.current.setProperties()
        print("logout success")
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
    private func setProperties() {
        self.name = PFUser.current()?["name"] as! String?
        self.username = PFUser.current()?["username"] as! String?
        self.email = PFUser.current()?["email"] as! String?
        self.interest = PFUser.current()?["interest"] as! String?
        self.type = PFUser.current()?["type"] as! String?
    }
    
}
