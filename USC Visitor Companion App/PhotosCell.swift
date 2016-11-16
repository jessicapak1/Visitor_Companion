//
//  PhotosCell.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 11/13/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class PhotosCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(UINib(nibName: "PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photosColectionViewCell")
        }
    }
    
    
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var blurBackground: UIVisualEffectView!
    var photos: [FlickrPhoto] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myBackgroundView.layer.cornerRadius = 15
        myBackgroundView.layer.masksToBounds = true
        blurBackground.layer.cornerRadius = 15
        blurBackground.layer.masksToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosColectionViewCell", for: indexPath) as! PhotosCollectionCell
        
        /* Change it to asynchronus background */
        
        //let url = URL(photos[indexPath.row].photoUrl)
        if photos.isEmpty {
            return cell
        }
        let data = try? Data(contentsOf: photos[indexPath.row].photoUrl as URL)
        cell.imageView.image = UIImage(data: data!)
        return cell
    }
    
    func populatePhotosArray(locationName: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FlickrProvider.fetchPhotosForLocationName(locationName: locationName, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                self.photos = flickrPhotos!
            } else {
                self.photos = []
                if (error!.code == FlickrProvider.Errors.invalidAccessErrorCode) {
                    ///DispatchQueue.main.async(execute: { () -> Void in
                        //self.showErrorAlert()
                    //})
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                // This thread was initially used to change some basic data contained within the enclosing table. Ultimately this thread is probably completely unnecessary (obviously I've just used it in order to print out the results of our query)
                
                print("\n")
                print("Raw photo data acquired through the FlickrProvider: ")
                print("\n")
                print(self.photos)
                print("\n")
                self.collectionView.reloadData()
            })
        })
    }
    
    /*
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
     */
}
