//
//  DescriptionCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/25/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var myBackgroundView: UIView!
    

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var locationTypeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myBackgroundView.layer.cornerRadius = 10
        myBackgroundView.layer.masksToBounds = true

        /*
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = myBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        myBackgroundView.addSubview(blurEffectView)
         */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
