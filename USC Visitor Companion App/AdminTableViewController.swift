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


class AdminTableViewController: UITableViewController,  InterestsViewDelegates, UIPickerViewDelegate, UIPickerViewDataSource {
    var mInterestsArray: [String] = [String]()
    var mInterestsForDatabase: [String] = [String]()
    var selectedLocationType: String = ""
    var locationTypes = ["Food", "Library", "Building", "Fountain", "Field"]
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTypePicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var interestsPicker: UIPickerView!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var locationsTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var addLocationValue: CLLocation?
    var locationName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        locationTypePicker.dataSource = self;
        locationTypePicker.delegate = self;
        
        print("location name inside admin ")
        print(locationName)
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
    
    }

    @IBAction func interestsButtonAction(_ sender: AnyObject) {
        
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
        else
        {
            let name = nameTextField.text
            let code = codeTextField.text            
            let description = descriptionTextView.text
            
            LocationData.shared.create(name: name!, code: code!, details: description!, location: addLocationValue!, interests:mInterestsForDatabase, locType: selectedLocationType, video: [], callback: {
                (succeeded) in
                if(succeeded) {
                    self.dismiss(animated: true, completion: nil)
                }
            });

        }
    }
    func userDidSaveMap(newLocation: CLLocation) {
        print("new location")
        addLocationValue = newLocation
        var locationString = "Location: "
        locationString.append((addLocationValue?.coordinate.latitude.description)!)
        locationString.append(", ")
        locationString.append((addLocationValue?.coordinate.longitude.description)!)
        self.locationLabel.text = locationString
    }
    
    func userDidSave(interestsArray: [String], interestsForDatabase: [String]) {
        mInterestsArray = interestsArray
        mInterestsForDatabase = interestsForDatabase
        var interestString = ""
    
        for i in (0..<interestsArray.count)
        {
            interestString.append(interestsArray[i] + " ")
        }
        self.interestsLabel.text = interestString
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
        if (segue.identifier == "admin_to_interests") {
            print("inside segue interests")
            //get a reference to the destination view controller
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.viewControllers.first as! InterestsViewController
            destinationVC.interestDelegate = self
            destinationVC.fromAdmin = true
        }
        /*
        if (segue.identifier == "map_to_admin") {
            print("inside segue interests")
            //get a reference to the destination view controller
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.viewControllers.first as! AdminMapViewController
            destinationVC.mapDelegate = self
        }
         */
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocationType = locationTypes[row]
    }
}
