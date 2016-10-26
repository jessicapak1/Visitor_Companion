//
//  DescriptionCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var locationTypeImage: UIImageView!

    @IBOutlet weak var locationTypeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
