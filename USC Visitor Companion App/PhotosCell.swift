//
//  PhotosCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 11/13/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class PhotosCell: UITableViewCell {
    
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myBackgroundView.layer.cornerRadius = 15
        myBackgroundView.layer.masksToBounds = true
        blurBackground.layer.cornerRadius = 15
        blurBackground.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
