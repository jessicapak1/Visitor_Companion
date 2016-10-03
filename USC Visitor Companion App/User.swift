//
//  User.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

class User: NSObject {
    
    // MARK: Current User
    static let current: User = User()
    
    
    // MARK: Properties
    var name: String? { willSet { self.update(value: newValue, forKey: "name") } }
    
    var username: String? { willSet { self.update(value: newValue, forKey: "username") } }
    
    var email: String? { willSet { self.update(value: newValue, forKey: "email") } }
    
    var interest: String? { willSet { self.update(value: newValue, forKey: "interest") } }
    
    var type: String? { willSet { self.update(value: newValue, forKey: "type") } }
    
    
    // MARK: Class Methods
    class func signup(name: String, username: String, password: String, email: String, type: String, callback: @escaping (Bool) -> Void) {
        let user = PFUser()
        user["name"] = name
        user["username"] = username
        user["password"] = password
        user["email"] = email
        user["interest"] = "General" 
        user["type"] = type
        user.signUpInBackground(block: {
            (succeeded, error) -> Void in
            User.current.update()
            callback(succeeded)
        })
    }
    
    class func login(username: String, password: String, callback: @escaping (Bool) -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password, block: {
            (user, error) -> Void in
            User.current.update()
            callback(error == nil)
        })
    }
    
    class func logout() {
        PFUser.logOut()
        User.current.update()
    }
    
    
    // MARK: Private Methods
    private func update() {
        self.name = PFUser.current()?["name"] as! String?
        self.username = PFUser.current()?["username"] as! String?
        self.email = PFUser.current()?["email"] as! String?
        self.interest = PFUser.current()?["interest"] as! String?
        self.type = PFUser.current()?["type"] as! String?
    }
    
    private func update(value: String?, forKey key: String) {
        PFUser.current()?[key] = value
        PFUser.current()?.saveInBackground()
    }
    
}
