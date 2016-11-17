//
//  LocationTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import FacebookShare

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
    @IBOutlet weak var directionsButton: UIBarButtonItem!
    @IBOutlet weak var shadowImage: UIImageView!
    
    var name : String = "" //this value will be provided in the prepareforsegue in the MapView.
    var current : Location? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        //make navbar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        //get current location from the database acording to the name provided in the prepareforsegue
        current = LocationData.shared.getLocation(withName: name)
        
        DispatchQueue.main.async {
            self.imageView.image = self.current?.image
            if (self.imageView.image == nil) {
                self.imageView.image = UIImage(named: "tommy_trojan_2")
                print("Error: did not find image in database, loading default (LocationTableViewController)")
            }
            self.tableView.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView.image = UIImage(named: "tommy_trojan_2")
    }
    
    /////////////  TABLE VIEW CODE  \\\\\\\\\\\\\\
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this will change acording to the data available for current location
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 5 { // video
            return 200
        } else if indexPath.row == 6 { // photos
            return 200
        }
        
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 { //title
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCellView") as! TitleCell
            cell.title.text = self.name
            return cell
        } else if indexPath.row == 1 { // blank
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCellView")!
            return cell
        } else if indexPath.row == 2 { // blank
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCellView")!
            return cell
        } else if indexPath.row == 3 { // description
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellView") as! DescriptionCell
            cell.descriptionLabel.text = current?.details!
            return cell
        } else if indexPath.row == 4 { // interests, this will change to checkin, share, and camera
            let cell = tableView.dequeueReusableCell(withIdentifier: "interestsCellView", for: indexPath) as! InterestsCell
            return cell
        } else if indexPath.row == 5 { // video
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCellView", for: indexPath) as! VideoCell
            return cell
        } else { // photos
            let cell = tableView.dequeueReusableCell(withIdentifier: "photosCellView")!
            return cell
        }
    }
    
    /////////  NAVIGATION BAR ITEMS CODE  \\\\\\\\\
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func directionsButtonPressed(_ sender: AnyObject) {
        let content = LinkShareContent(url: URL(string: "http://viterbi.usc.edu")!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .web
        shareDialog.failsOnInvalidData = true
        shareDialog.completion =  {
            result in
            print("Shared to Facebook")
        }
        try? shareDialog.show()
    }

}
