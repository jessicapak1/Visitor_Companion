//
//  User.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 9/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import Parse
import FacebookCore
import FacebookLogin

enum UserType: String {
    case parent = "Parent"
    case prospective = "Prospective Student"
    case current = "Current Student"
    case admin = "Administrator"
    case none = "None" // should never be stored on database
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
    
    var type: UserType = .none { willSet { User.current.update(value: newValue.rawValue, forKey: UserKey.type.rawValue) } }
    
    
    // MARK: Class Methods
    class func signup(username: String, password: String, callback: @escaping () -> Void) {
        let user = PFUser()
        user[UserKey.username.rawValue] = username
        user[UserKey.password.rawValue] = password
        user[UserKey.email.rawValue] = username
        user.signUpInBackground(block: {
            (succeeded, error) in
            User.current.update()
            callback()
        })
    }
    
    class func signupWithFacebook(callback: @escaping () -> Void) {
        let loginManager = LoginManager()
        loginManager.loginBehavior = .web
        loginManager.logIn([.email, .publicProfile], viewController: nil, completion: {
            (loginResult) in
            switch loginResult {
            case .success(grantedPermissions: _, declinedPermissions: _, token: let accessToken):
                User.current.signupThroughGraphRequest(withAccessToken: accessToken, callback:{
                    User.current.update()
                    callback()
                })
            case .failed(_):
                callback()
                break
            case .cancelled:
                callback()
                break
            }
        })
    }
    
    class func login(username: String, password: String, callback: @escaping () -> Void) {
        PFUser.logInWithUsername(inBackground: username, password: password, block: {
            (user, error) in
            User.current.update()
            callback()
        })
    }
    
    class func loginWithFacebook(callback: @escaping () -> Void) {
        let loginManager = LoginManager()
        loginManager.loginBehavior = .web
        loginManager.logIn([.email, .publicProfile], viewController: nil, completion: {
            (loginResult) in
            switch loginResult {
            case .success(grantedPermissions: _, declinedPermissions: _, token: let accessToken):
                User.current.loginThroughGraphRequest(withAccessToken: accessToken, callback: {
                    User.current.update()
                    callback()
                })
            case .failed(_):
                callback()
                break
            case .cancelled:
                callback()
                break
            }
        })
    }
    
    class func logout() {
        PFUser.logOut()
        LoginManager().logOut()
        User.current.update()
    }
    
    
    // MARK: Private Methods
    func delete() {
        PFUser.current()?.deleteInBackground(block: {
            (succeeded) in
            User.logout()
            User.current.update()
        })
    }
    
    func update() {
        User.current.name = PFUser.current()?[UserKey.name.rawValue] as! String?
        User.current.username = PFUser.current()?[UserKey.username.rawValue] as! String?
        User.current.email = PFUser.current()?[UserKey.email.rawValue] as! String?
        User.current.interest = PFUser.current()?[UserKey.interest.rawValue] as! String?
        if let type = PFUser.current()?[UserKey.type.rawValue] as! String? {
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
    
    private func signupThroughGraphRequest(withAccessToken accessToken: AccessToken, callback: @escaping () -> Void) {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], accessToken: accessToken, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion)
        request.start({
            (response, result) in
            switch result {
            case .success(response: let value):
                let values = value.dictionaryValue!
                let id = values["id"] as! String
                let name = values["name"] as! String
                let email = values["email"] as! String
                // id should be hashed with SHA256 then stored as password
                User.signup(username: email, password: id, callback: {
                    if User.current.exists {
                        User.current.name = name
                        User.current.type = UserType.prospective
                        User.current.interest = "General"
                    }
                    callback()
                })
            case .failed(_):
                break
            }
        })
    }
    
    private func loginThroughGraphRequest(withAccessToken accessToken: AccessToken, callback: @escaping () -> Void) {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "email"], accessToken: accessToken, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion)
        request.start({
            (response, result) in
            switch result {
            case .success(response: let value):
                let values = value.dictionaryValue!
                let id = values["id"] as! String
                let email = values["email"] as! String
                // id should be hashed with SHA256 then stored as password
                User.login(username: email, password: id, callback: {
                    callback()
                })
            case .failed(_):
                break
            }
        })
    }
    
}
