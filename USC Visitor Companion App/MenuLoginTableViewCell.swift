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
    func signUpButtonPressed()
}

class MenuLoginTableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let defaultHeight: CGFloat = 163.0
    
    var delegate: MenuLoginTableViewCellDelegate?
    
    
    // MARK: IBOutlets
    @IBOutlet weak var loginButton: ShadowButton! {
        didSet {
            // make the corners round
            self.loginButton.layer.cornerRadius = 5.0
            self.loginButton.addShadow()
        }
    }
    
    @IBOutlet weak var signUpButton: ShadowButton! {
        didSet {
            // make the corners round
            self.signUpButton.layer.cornerRadius = 5.0
            self.signUpButton.addShadow()
        }
    }
    
    
    // MARK: IBAction Methods
    @IBAction func loginButtonPressed() {
        if let delegate = self.delegate {
            delegate.loginButtonPressed()
        }
    }
    
    @IBAction func signUpButtonPressed() {
        if let delegate = self.delegate {
            delegate.signUpButtonPressed()
        }
    }
    
}
