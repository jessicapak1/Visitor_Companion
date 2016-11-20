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

class LocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    override func viewWillAppear(_ animated: Bool) {
        //make navbar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        current = LocationData.shared.getLocation(withName: name)
        
//        DispatchQueue.global().async {
        
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
//            self.imageView.image = self.current?.image
//            if (self.imageView.image == nil) {
//                self.imageView.image = UIImage(named: "tommy_trojan_2")
//                print("Error: did not find image in database, loading default (LocationTableViewController)")
//            }
//            DispatchQueue.main.sync {
//                self.tableView.setNeedsDisplay()
//            }
//        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return cell
        }
        
        return UITableViewCell()
    }
    
    //NAVIGATION BAR ITEMS CODE
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
