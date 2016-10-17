//
//  SearchResultTableViewCell.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 10/4/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let defaultHeight: CGFloat = 60.0
    
    
    // MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var interestsLabel: UILabel!
    
}
