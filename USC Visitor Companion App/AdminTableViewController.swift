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



class AdminTableViewController: UITableViewController,  InterestsViewDelegates, MapViewDelegates{
    var mInterestsArray: [String] = [String]()
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
//            let name = nameTextField.text
//            let code = codeTextField.text            
//            let description = descriptionTextView.text
//            
//            let location = CLLocation(latitude: 34.0224, longitude: 118.2851)

//            LocationData.shared.create(name: name!, code: code!, details: description!, location: location, interests:interestsArray, locType: , callback: {() -> Void in });

        }
    }
    
    func userDidSave(interestsArray: [String]) {
        print("did save function");
        mInterestsArray = interestsArray
        var interestString = ""
        for i in (0..<interestsArray.count)
        {
            interestString = interestString + interestsArray[i] + " "
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
        if (segue.identifier == "admin_to_interest") {
            print("inside segue interests")
            //get a reference to the destination view controller
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.viewControllers.first as! InterestsViewController
            destinationVC.interestDelegate = self
            destinationVC.fromAdmin = true
        }
        if (segue.identifier == "admin_to_map") {
            print("inside segue interests")
            //get a reference to the destination view controller
            let navigationVC = segue.destination as! UINavigationController
            let destinationVC = navigationVC.viewControllers.first as! MapViewController
            destinationVC.mapDelegate = self
            destinationVC.fromAdmin = true
        }
    }
}
