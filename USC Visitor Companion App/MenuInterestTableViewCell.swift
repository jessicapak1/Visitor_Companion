//
//  MenuInterestTableViewCell.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

protocol MenuInterestTableViewCellDelegate {
    func interestButtonPressed()
}

class MenuInterestTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var interestButton: UIButton! {
        didSet {
            self.interestButton.layer.cornerRadius = 5.0
        }
    }
    
    
    // MARK: Properties
    static let defaultHeight: CGFloat = 140.0
    
    var delegate: MenuInterestTableViewCellDelegate?
    
    
    // MARK: IBAction Methods
    @IBAction func interestButtonPressed() {
        if let delegate = self.delegate {
            delegate.interestButtonPressed()
        }
    }
    
}
