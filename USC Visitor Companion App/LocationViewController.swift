//
//  LocationViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let mainImage = UIImageViewModeScaleAspect(frame: CGRect(x: 0, y: 0, width: 375, height: 666))
    
    var selectedLocation : Location? = nil
    
    var locDescription : String = ""
    var locTaggedInterests : String = ""
    
    //make navbar transparent
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = view
        self.view.bringSubview(toFront: collectionView)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.collectionView.backgroundColor = UIColor.clear
        

        
        //load image from database acording to location
        //then set the loaded image into the image view
        //imageView.image = mainImage
        mainImage.image = UIImage(named: "tommy trojan")
        mainImage.contentMode = .scaleAspectFill
        mainImage.backgroundColor = UIColor.black
        view.addSubview(mainImage)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LocationViewController.animateImage))
        mainImage.addGestureRecognizer(tapGesture)
        
        //load description from database and then load it to the label
        locDescription = "The bronze statue of a Trojan warrior standing on the corner of University and 36th was a gift of the Alumni Association in 1930"
        locTaggedInterests = "General"
    }
    
    func animateImage() {
        
        if mainImage.contentMode == .scaleAspectFill {
            mainImage.animate( .fit, frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), duration: 0.4)
            self.view.bringSubview(toFront: imageView)
        } else {
            mainImage.animate( .fill, frame: CGRect(x: 0, y: 0, width: 375, height: 666), duration: 0.4)
            self.view.bringSubview(toFront: collectionView)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 { //description
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "descriptionCell", for: indexPath) as! DescriptionCell
            cell.descriptionTextView.text = locDescription;
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else if indexPath.row == 1 { //intersts
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestsCell", for: indexPath) as! InterestsCell
            cell.temporaryInterestsLabel.text = locTaggedInterests;
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else if indexPath.row == 2 { //media
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! MediaCell
            cell.videosAndSoundsLabel.text = "videos and sounds"
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else if indexPath.row == 3 { //instagram
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialMediaCell", for: indexPath) as! SocialMediaCell
            cell.instagramLabel.text = "instragram"
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 15
            return cell
        } else {
            let cell = UICollectionViewCell()
            cell.backgroundColor = UIColor.brown
            return cell
        }
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
