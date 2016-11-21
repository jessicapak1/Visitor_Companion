//
//  LocationTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import MapKit

// ONLY ACCEPTS YOUTUBE LINKS, REFERENCE VideoCell.swift please

class LocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwiftPhotoGalleryDelegate, SwiftPhotoGalleryDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.register(UINib(nibName: "BlankCellView", bundle: nil), forCellReuseIdentifier: "blankCellView")
            self.tableView.register(UINib(nibName: "DescriptionCellView", bundle: nil), forCellReuseIdentifier: "descriptionCellView")
            self.tableView.register(UINib(nibName: "MediaCellView", bundle: nil), forCellReuseIdentifier: "mediaCellView")
            self.tableView.register(UINib(nibName: "InterestsCellView", bundle: nil), forCellReuseIdentifier: "interestsCellView")
            self.tableView.register(UINib(nibName: "TitleCellView", bundle: nil), forCellReuseIdentifier: "titleCellView")
            self.tableView.register(UINib(nibName: "VideoCellView", bundle: nil), forCellReuseIdentifier: "videoCellView")
            self.tableView.register(UINib(nibName: "PhotosCellView", bundle: nil), forCellReuseIdentifier: "photosCellView")
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    
    var name : String = "" // this value will be provided in the prepareforsegue in the MapView.
    var current : Location? = nil
    var closeProximity : Bool = false
    
    var identifiers: [String] = ["titleCellView", "descriptionCellView", "interestsCellView"]
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make navbar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        current = LocationData.shared.getLocation(withName: name)
        
        current?.getImage(callback: {
            (image) in
            self.imageView.image = image
        })
        
        if let videos = current?.video {
            for video in videos {
                if video.lowercased().contains("youtube") {
                    self.identifiers.append(video)
                }
            }
        }
        
        self.identifiers.append("photosCellView")
    }
    
    /////////////  TABLE VIEW CODE  \\\\\\\\\\\\\\
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this will change acording to the data available for current location
        return self.identifiers.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.identifiers[indexPath.row] == "titleCellView" { // title
            return 450
        } else if self.identifiers[indexPath.row].lowercased().contains("youtube") { // video
            return 200
        } else if self.identifiers[indexPath.row] == "photosCellView" { // photos
            return 215
        }
        
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.identifiers[indexPath.row] == "titleCellView" { //title
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCellView") as! TitleCell
            cell.title.text = self.name
            return cell
        } else if self.identifiers[indexPath.row] == "descriptionCellView" { // description
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellView") as! DescriptionCell
            cell.descriptionLabel.text = current?.details!
            return cell
        } else if self.identifiers[indexPath.row] == "interestsCellView" { // interests, this will change to checkin, share, and camera
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestsCellView", for: indexPath) as! InterestsCell
            cell.setCurrentLocation(currentLocation: current!, isClose: closeProximity)
            return cell
        } else if self.identifiers[indexPath.row].lowercased().contains("youtube") {// < pictureIndex { // video HACKY! SHOULD BE FIXED
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCellView", for: indexPath) as! VideoCell
            cell.selectVideo(withUrl: self.identifiers[indexPath.row])
            return cell
        } else if self.identifiers[indexPath.row] == "photosCellView" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photosCellView") as! PhotosCell
            print("\n called form deque in table view")
            cell.populatePhotosArray(locationName: name)
            cell.collectionView.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let photosCell = cell as! PhotosCell
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: self.identifiers.count-1, section: 0)) as! PhotosCell
        self.images = cell.images
        // Do any additional setup after loading the view.
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        
        gallery.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        gallery.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        gallery.imageCollectionView.backgroundColor = UIColor.black
        gallery.hidePageControl = true
        //gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.7)
        //gallery.currentPageIndicatorTintColor = UIColor.white
        
        self.present(gallery, animated: true, completion: nil)
    }
    
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return self.images.count
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        
        return self.images[forIndex]
    }
    
    // MARK: SwiftPhotoGalleryDelegate Methods
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }

    //NAVIGATION BAR ITEMS CODE
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
