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


enum UserKey: String {
    case name = "name"
    case username = "username"
    case password = "password"
    case email = "email"
    case interest = "interest"
    case type = "type"
}


class User: NSObject {
    
    // MARK: Current User
    static let current: User = User()
    
    
    // MARK: Properties
    var exists: Bool { get { return PFUser.current() != nil } }
    
    var name: String? { willSet { User.current.update(value: newValue, forKey: UserKey.name.rawValue) } }
    
    var username: String? { willSet { User.current.update(value: newValue, forKey: UserKey.username.rawValue) } }
    
    var email: String? { willSet { User.current.update(value: newValue, forKey: UserKey.email.rawValue) } }
    
    var interest: String? { willSet { User.current.update(value: newValue, forKey: UserKey.interest.rawValue) } }
    
    var type: UserType = .none  // should never be set after signup
    
    
    // MARK: Class Methods
    class func signup(name: String, username: String, password: String, email: String, type: String) {
        let user = PFUser()
        user[UserKey.name.rawValue] = name
        user[UserKey.username.rawValue] = username
        user[UserKey.password.rawValue] = password
        user[UserKey.email.rawValue] = email
        user[UserKey.interest.rawValue] = "General"
        user[UserKey.type.rawValue] = type
        do {
            try user.signUp()
        } catch {
            print("ERROR: User Class - Failed to sign up with username \(username)")
        }
        User.current.update()
    }
    
    class func login(username: String, password: String) {
        do {
            try PFUser.logIn(withUsername: username, password: password)
        } catch {
            print("ERROR: User Class - Failed to login with username \(username)")
        }
        User.current.update()
    }
    
    class func logout() {
        PFUser.logOut()
        User.current.update()
    }
    
    
    // MARK: Private Methods
    func update() {
        User.current.name = PFUser.current()?[UserKey.name.rawValue] as! String?
        User.current.username = PFUser.current()?[UserKey.username.rawValue] as! String?
        User.current.email = PFUser.current()?[UserKey.email.rawValue] as! String?
        User.current.interest = PFUser.current()?[UserKey.interest.rawValue] as! String?
        let type = PFUser.current()?[UserKey.type.rawValue] as! String?
        if let type = type {
            if type == UserType.prospective.rawValue {
                User.current.type = .prospective
            } else if type == UserType.current.rawValue {
                User.current.type = .current
            } else if type == UserType.parent.rawValue {
                User.current.type = .parent
            } else if type == UserType.admin.rawValue {
                User.current.type = .admin
            }
        } else {
            User.current.type = .none  // user did not sign up properly
        }
    }
    
    private func update(value: Any?, forKey key: String) {
        PFUser.current()?[key] = value
        do { try PFUser.current()?.save() } catch { }
    }
    
}
