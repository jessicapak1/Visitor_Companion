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
    
    // MARK: Properties
    let links: [String: String] = [
        "General": "http://viterbi.usc.edu",
        "Computer Science": "http://cs.usc.edu",
    ]
    

    // MARK: IBOutlets
    @IBOutlet weak var interestButton: ShadowButton! {
        didSet {
            // make the corners round
            self.interestButton.layer.cornerRadius = 5.0
            self.interestButton.addShadow()
        }
    }
    
    
    // MARK: Properties
    static let defaultHeight: CGFloat = 130.0
    
    var delegate: MenuInterestTableViewCellDelegate?
    
    
    // MARK: IBAction Methods
    @IBAction func interestButtonPressed() {
        if let delegate = self.delegate {
            delegate.interestButtonPressed()
        }
    }
    
}
