//
//  InterestsCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/27/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class InterestsCell: UITableViewCell {

    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var interestsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myBackgroundView.layer.cornerRadius = 15
        myBackgroundView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
