//
//  AdminTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AdminTableViewController: UITableViewController {
    var interestsArray: [String] = [String]()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var interestsPicker: UIPickerView!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var locationsTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var addLocationValue: CLLocationCoordinate2D?
    var locationName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let locationObject = LocationData.shared.getLocation(withName: locationName)
        self.nameTextField.text = locationObject?.name
        self.codeTextField.text = locationObject?.code
        self.descriptionTextView.text = locationObject?.details
        if(!interestsArray.isEmpty)
        {
            var interestString = ""
            for i in (0..<interestsArray.count)
            {
                interestString = interestString + interestsArray[i] + " "
            }
            self.interestsLabel.text = interestString
        }
        if let locationObject = LocationData.shared.getLocation(withName: locationName)
        {
            self.nameTextField.text = locationObject.name
            self.codeTextField.text = locationObject.code
            self.descriptionTextView.text = locationObject.details
            let array: [String] = locationObject.interests!
                var interestString = ""
                for i in (0..<array.count)
                {
    interestString = interestString + array[i] + " "
                }
                self.interestsLabel.text = interestString
        }
    }
    @IBAction func locationsButtonAction(_ sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    @IBAction func interestsButtonAction(_ sender: AnyObject) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "interests")
        self.present(viewController, animated: true, completion: nil)
        
    }
    @IBAction func addButtonAction(_ sender: AnyObject) {
        if((nameTextField.text?.isEmpty)! || (descriptionTextView.text?.isEmpty)!)
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            
        } else if(codeTextField.text?.characters.count != 3)
        {
            let alertController = UIAlertController(title: "Error", message: "The code needs to be 3 characters!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            
        }
            //        else if() locations input verification
            //        {
            //
            //        }
        else
        {

//            let name = nameTextField.text
//            let code = codeTextField.text            
//            let location = CLLocation(latitude: 34.0224, longitude: 118.2851)
//
//            var interests = [String]()
//            let description = descriptionTextView.text
//            LocationData.shared.create(name: name!, code: code!, details: description!, location: location, interests:interests, callback: {() -> Void in });

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 4 { // link with facebook
            // do something
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("inside segue")
        if (segue.identifier == "interests") {
            print("inside segue interests")
            //get a reference to the destination view controller
            let destinationVC:InterestsViewController = segue.destination as! InterestsViewController
            
            interestsArray = destinationVC.interests
            for i in (0..<interestsArray.count) {
                print(interestsArray[i])
            }
        }
    }
}
