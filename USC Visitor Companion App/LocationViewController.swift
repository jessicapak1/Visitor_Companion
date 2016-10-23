//
//  LocationViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainImage = UIImageViewModeScaleAspect(frame: CGRect(x: 0, y: 0, width: 375, height: 188))
    
    var selectedLocation : Location? = nil
    
    
    var locDescription : String = ""
    var locTaggedInterests : String = ""
    //make navbar transparent
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
