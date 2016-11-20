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
//        if images.count > 5 {
//            return 2
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            if images.count >= 5 {
//                return 5
//            } else {
//                return images.count
//            }
//        } else {
//            if images.count >= 10 {
//                return 5
//            } else {
//                return images.count - 5
//            }
//        }
        return self.images.count
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                         sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSize(width: self.collectionView.bounds.size.width/4, height: self.collectionView.bounds.size.width/2)
        //let size = CGSize(width: 90, height: 82)
        return size
    }
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosColectionViewCell", for: indexPath) as! PhotosCollectionCell
        
        /* Change it to asynchronus background */
        
        //let url = URL(photos[indexPath.row].photoUrl)
        print("called form deque in collection view")
        if self.images.isEmpty {
            return cell
        }
        //let data = try? Data(contentsOf: photos[indexPath.item].photoUrl as URL)
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func populatePhotosArray(locationName: String) {
        if self.images.count > 0 {
            return
        }
        //DispatchQueue.main.async(execute: { () -> Void in
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
            //DispatchQueue.main.async(execute: { () -> Void in
                // This thread was initially used to change some basic data contained within the enclosing table. Ultimately this thread is probably completely unnecessary (obviously I've just used it in order to print out the results of our query)
                
                print("\n")
                print("Loaded \(self.photos.count) photos ")
                print("\n")
            
            
            print("about to load images")
            DispatchQueue.global().sync {
                var bTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
                bTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    UIApplication.shared.endBackgroundTask(bTask)
                    bTask = UIBackgroundTaskInvalid
                })
                
                print(UIApplication.shared.backgroundTimeRemaining)
                
                
                for var i in (0..<self.photos.count) {
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

            //})
        })
        //})
        
        
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
