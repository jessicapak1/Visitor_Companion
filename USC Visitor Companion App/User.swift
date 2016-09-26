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
    
    static let current: User = User()
    
    func username() -> String {
        return (PFUser.current()?.username)!
    }
    
    func email() -> String {
        return (PFUser.current()?.email)!
    }
    
    class func login(username: String, password: String) {
        do {
            try PFUser.logIn(withUsername: username, password: password)
        } catch {
            print("cannot login user")
        }
    }
    
    class func logout() {
        // remove all user tokens
        PFUser.logOut()
    }
    
}
