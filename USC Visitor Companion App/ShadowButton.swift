//
//  ShadowButton.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 11/5/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {
    
    func addShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
    }
    
}
