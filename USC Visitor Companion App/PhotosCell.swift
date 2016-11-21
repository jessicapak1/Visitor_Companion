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
    var images : [UIImage] = []
    
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

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosColectionViewCell", for: indexPath) as! PhotosCollectionCell
        
        print("called form deque in collection view")
        if self.images.isEmpty {
            return cell
        }

        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    func populatePhotosArray(locationName: String) {
        if self.images.count > 0 {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FlickrProvider.fetchPhotosForLocationName(locationName: locationName, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                self.photos = flickrPhotos!
            } else {
                self.photos = []
                if (error!.code == FlickrProvider.Errors.invalidAccessErrorCode) {
                }
            }

            print("about to load images")
            DispatchQueue.global().sync {
                var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
                bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    UIApplication.shared.endBackgroundTask(bTask)
                    bTask = UIBackgroundTaskInvalid
                })
                
                print(UIApplication.shared.backgroundTimeRemaining)
                
                
                for i in (0..<self.photos.count) {
                    let imageData : Data = try! Data(contentsOf: self.photos[i].photoUrl as URL)
                    let image = UIImage(data: imageData)
                    self.images.append(image!)
                    //to the main queue
                    if i > 7 {
                        break;
                    }
                    
                    DispatchQueue.main.sync {
                        let indexpath = IndexPath(row: i, section: 0)
                        self.collectionView.insertItems(at: [indexpath])
                    }
                }
                self.collectionView.reloadData()
                UIApplication.shared.endBackgroundTask(bTask)
                bTask = UIBackgroundTaskInvalid
            }
        })
    }
}
