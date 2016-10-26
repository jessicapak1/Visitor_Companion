//
//  LocationTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Edgar Lugo on 10/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class LocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.register(UINib(nibName: "BlankCellView", bundle: nil), forCellReuseIdentifier: "blankCellView")
            self.tableView.register(UINib(nibName: "DescriptionCellView", bundle: nil), forCellReuseIdentifier: "descriptionCellView")
            self.tableView.register(UINib(nibName: "MediaCellView", bundle: nil), forCellReuseIdentifier: "mediaCellView")
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var directionsButton: UIBarButtonItem!
    @IBOutlet weak var shadowImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageViewModeScaleAspect!
    
    //let mainImage = UIImageViewModeScaleAspect(frame: CGRect(x: 0, y: 0, width: 375, height: 170))
    var name : String = ""
    var current : Location? = nil
    
    //make navbar transparent
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = name

        current = LocationData.shared.getLocation(withName: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainImage.image = UIImage(named: "Tommy Trojan")
        mainImage.contentMode = .scaleAspectFill
        mainImage.backgroundColor = UIColor.black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LocationTableViewController.animateImage))
        mainImage.addGestureRecognizer(tapGesture)
        //imageView.image = UIImage(named: name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateImage() {
        
        if mainImage.contentMode == .scaleAspectFill {
            self.view.bringSubview(toFront: mainImage)
            mainImage.animate( .fit, frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), duration: 0.4)
        } else {
            mainImage.animate( .fill, frame: CGRect(x: 0, y: 0, width: 375, height: 200), duration: 0.4)
            //sleep(4)
            self.view.bringSubview(toFront: tableView)
            self.view.bringSubview(toFront: shadowImage)
        }
        
    }
    
    // TABLE VIEW CODE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        }
        return 149.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCellView")!
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LocationTableViewController.animateImage))
            cell.addGestureRecognizer(tapGesture)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellView") as! DescriptionCell
            cell.descriptionLabel.text = current?.details!
            return cell
        }
        /*else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCell", for: indexPath)
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "instagramCell", for: indexPath)
            return cell
        } */else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCellView")!
            return cell
        }
    }
    
    //NAVIGATION BAR ITEMS CODE
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func directionsButtonPressed(_ sender: AnyObject) {
        
        //get direcitons and dismiss
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
