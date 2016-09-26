//
//  OptionsView.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class OptionsView: UIView {

    @IBOutlet weak var optionsView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "OptionsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    @IBAction func locationButtonPressed(_ sender: AnyObject) {
//        let rootViewController = self.window!.rootViewController
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//     
//        let vc : AnyObject! = mainStoryboard.instantiateViewController(withIdentifier: "location")
//        mainStoryboard.presentViewController(vc, animated: true, completion: nil)
     
    }
    
    
    @IBAction func hungryButtonPressed(_ sender: AnyObject) {
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
    }
    
    @IBOutlet weak var appPreferencesButtonPressed: UIButton!
    
}
