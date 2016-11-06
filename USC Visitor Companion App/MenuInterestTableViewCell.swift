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
    @IBOutlet weak var interestButton: UIButton! {
        didSet {
            // make the corners round
            self.interestButton.layer.cornerRadius = 5.0
            // add a drop shadow
            self.interestButton.layer.shadowColor = UIColor.darkGray.cgColor
            self.interestButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
            self.interestButton.layer.shadowOpacity = 1.0
            self.interestButton.layer.shadowRadius = 1.5
        }
    }
    
    @IBOutlet weak var websiteButton: UIButton! {
        didSet {
            // make the corners round
            self.websiteButton.layer.cornerRadius = 5.0
            // add a drop shadow
            self.websiteButton.layer.shadowColor = UIColor.darkGray.cgColor
            self.websiteButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
            self.websiteButton.layer.shadowOpacity = 1.0
            self.websiteButton.layer.shadowRadius = 1.5
        }
    }
    
    
    // MARK: Properties
    static let defaultHeight: CGFloat = 172.0
    
    var delegate: MenuInterestTableViewCellDelegate?
    
    
    // MARK: IBAction Methods
    @IBAction func interestButtonPressed() {
        if let delegate = self.delegate {
            delegate.interestButtonPressed()
        }
    }
    
    @IBAction func websiteButtonPressed() {
        let interest = self.interestButton.currentTitle
        if let interest = interest {
            let link = self.links[interest]
            if let link = link {
                UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
