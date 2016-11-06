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
    static let defaultHeight: CGFloat = 155.0
    
    var delegate: MenuLoginTableViewCellDelegate?
    
    
    // MARK: IBOutlets
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            // make the corners round
            self.loginButton.layer.cornerRadius = 5.0
            // add a drop shadow
            self.loginButton.layer.shadowColor = UIColor.darkGray.cgColor
            self.loginButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
            self.loginButton.layer.shadowOpacity = 1.0
            self.loginButton.layer.shadowRadius = 1.5
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            // make the corners round
            self.signUpButton.layer.cornerRadius = 5.0
            // add a drop shadow
            self.signUpButton.layer.shadowColor = UIColor.darkGray.cgColor
            self.signUpButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
            self.signUpButton.layer.shadowOpacity = 1.0
            self.signUpButton.layer.shadowRadius = 1.5
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
