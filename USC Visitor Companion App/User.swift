//
//  User.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse

enum UserType: String {
    case parent = "Parent"
    case prospective = "Prospective Student"
    case current = "Current Student"
    case admin = "Administrator"
    case none = "None"  // should never be stored on database
}

class User: NSObject {
    
    // MARK: Current User
    static let current: User = User()
    
    
    // MARK: Properties
    var name: String? { willSet { User.current.update(value: newValue, forKey: "name") } }
    
    var username: String? { willSet { User.current.update(value: newValue, forKey: "username") } }
    
    var email: String? { willSet { User.current.update(value: newValue, forKey: "email") } }
    
    var interest: String? { willSet { User.current.update(value: newValue, forKey: "interest") } }
    
    var type: UserType = .none  // should never be set after signup
    
    
    // MARK: Class Methods
    class func signup(name: String, username: String, password: String, email: String, type: UserType) {
        let user = PFUser()
        user["name"] = name
        user["username"] = username
        user["password"] = password
        user["email"] = email
        user["interest"] = "General" 
        user["type"] = type
        do { try user.signUp() } catch { }
        User.current.update()
    }
    
    class func login(username: String, password: String) {
        do { try PFUser.logIn(withUsername: username, password: password) } catch { }
        User.current.update()
    }
    
    class func logout() {
        PFUser.logOut()
        User.current.update()
    }
    
    
    // MARK: Private Methods
    private func update() {
        User.current.name = PFUser.current()?["name"] as! String?
        User.current.username = PFUser.current()?["username"] as! String?
        User.current.email = PFUser.current()?["email"] as! String?
        User.current.interest = PFUser.current()?["interest"] as! String?
        let type = PFUser.current()?["type"] as! String?
        if let type = type {
            if type == UserType.parent.rawValue {
                User.current.type = .parent
            } else if type == UserType.prospective.rawValue {
                User.current.type = .prospective
            } else if type == UserType.current.rawValue {
                User.current.type = .current
            } else if type == UserType.admin.rawValue {
                User.current.type = .admin
            }
        } else {
            User.current.type = .none  // user did not signup properly
        }
    }
    
    private func update(value: Any?, forKey key: String) {
        PFUser.current()?[key] = value
        do { try PFUser.current()?.save() } catch { }
    }
    
}
