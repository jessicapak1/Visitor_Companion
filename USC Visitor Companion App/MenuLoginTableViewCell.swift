//
//  MenuLoginTableViewCell.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/16/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

protocol MenuLoginTableViewCellDelegate {
    func loginButtonPressed()
    func signupButtonPressed()
}

class MenuLoginTableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let defaultHeight: CGFloat = 150.0
    
    var delegate: MenuLoginTableViewCellDelegate?
    
    
    // MARK: IBOutlets
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var signupButton: UIButton! {
        didSet {
            self.signupButton.layer.cornerRadius = 10.0
        }
    }
    
    
    // MARK: IBAction Methods
    @IBAction func loginButtonPressed() {
        if let delegate = self.delegate {
            delegate.loginButtonPressed()
        }
    }
    
    @IBAction func signupButtonPressed() {
        if let delegate = self.delegate {
            delegate.signupButtonPressed()
        }
    }
    
}
