//
//  VideoCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 11/11/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
