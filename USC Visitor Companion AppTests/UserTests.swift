//
//  UserTests.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/9/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import XCTest
@testable import USC_Visitor_Companion_App

class UserTests: XCTestCase {
    
    func testPerformanceLogin() {
        self.measure {
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.name)
            if let name = User.current.name {
                XCTAssertEqual(name, "UnitTestName")
            }
            XCTAssertNotNil(User.current.username)
            if let username = User.current.username {
                XCTAssertEqual(username, "UnitTestUsername")
            }
            XCTAssertNotNil(User.current.email)
            if let email = User.current.email {
                XCTAssertEqual(email, "UnitTestEmail@usc.edu")
            }
            XCTAssertNotNil(User.current.interest)
            if let interest = User.current.interest {
                XCTAssertEqual(interest, "UnitTestInterest")
            }
            User.logout()
        }
    }
    
    func testPerformanceLogout() {
        self.measure {
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            User.logout()
            XCTAssertNil(User.current.name)
            XCTAssertNil(User.current.username)
            XCTAssertNil(User.current.email)
            XCTAssertNil(User.current.interest)
        }
    }
    
    func testPerformanceNameChange() {
        self.measure {
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.name)
            if let name = User.current.name {
                XCTAssertEqual(name, "UnitTestName")
            }
            User.current.name = "TemporaryName"
            User.logout()
            
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.name)
            if let name = User.current.name {
                XCTAssertEqual(name, "TemporaryName")
            }
            User.current.name = "UnitTestName"
            User.logout()
        }
    }
    
    func testPerformanceUsernameChange() {
        self.measure {
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.username)
            if let username = User.current.username {
                XCTAssertEqual(username, "UnitTestUsername")
            }
            User.current.username = "TemporaryUsername"
            User.logout()
            
            User.login(username: "TemporaryUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.username)
            if let username = User.current.username {
                XCTAssertEqual(username, "TemporaryUsername")
            }
            User.current.username = "UnitTestUsername"
            User.logout()
        }
    }
    
    func testPerformanceEmailChange() {
        self.measure {
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.email)
            if let email = User.current.email {
                XCTAssertEqual(email, "UnitTestEmail@usc.edu")
            }
            User.current.email = "TemporaryEmail@usc.edu"
            User.logout()
            
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.email)
            if let email = User.current.email {
                XCTAssertEqual(email, "TemporaryEmail@usc.edu")
            }
            User.current.email = "UnitTestEmail@usc.edu"
            User.logout()
        }
    }
    
    func testPerformanceInterestChange() {
        self.measure {
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.interest)
            if let interest = User.current.interest {
                XCTAssertEqual(interest, "UnitTestInterest")
            }
            User.current.interest = "TemporaryInterest"
            User.logout()
            
            User.login(username: "UnitTestUsername", password: "UnitTestPassword")
            XCTAssertNotNil(User.current.interest)
            if let interest = User.current.interest {
                XCTAssertEqual(interest, "TemporaryInterest")
            }
            User.current.interest = "UnitTestInterest"
            User.logout()
        }
    }
    
}
