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
    
    // MARK: Current User
    static let current: User = User()
    
    
    // MARK: User Properties
    var exists: Bool { get { return PFUser.current() != nil } }
    
    var name: String? { get { return self.value(forKey: "name") } }
    
    var username: String? { get { return self.value(forKey: "username") } }
    
    var email: String? { get { return self.value(forKey: "email") } }
    
    var interest: String? { get { return self.value(forKey: "interest") } }
    
    var type: String? { get { return self.value(forKey: "type") } }

    
    // MARK: User Methods
    class func signup(username: String, password: String, email: String) {
        let user = PFUser()
        user.setValue(username, forKey: "username")
        user.setValue(password, forKey: "password")
        user.setValue(email, forKey: "email")
        user.signUpInBackground(block: {
            (succeeded, error) in
            if succeeded {
                print("signup success")
            } else {
                print("signup error")
            }
        })
    }
    
    class func login(username: String, password: String) {
        do {
            try PFUser.logIn(withUsername: username, password: password)
            print("login success")
        } catch {
            print("login error")
        }
    }
    
    class func logout() {
        PFUser.logOut()
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
    private func value(forKey key: String) -> String? {
        if let currentUser = PFUser.current() {
            return currentUser.value(forKey: key) as? String
        }
        return nil
    }
    
}
