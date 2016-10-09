//
//  AdminTableViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 10/2/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class AdminTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var interestsPicker: UIPickerView!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var locationsTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBAction func locationsButtonAction(_ sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    @IBAction func interestsButtonAction(_ sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "interests") as! InterestsViewController
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
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
//            //            let interests = interestsLabel.text
//            
//            var interests = [String]()
//            let location = locationsTextField.text
//            let description = descriptionTextView.text
            //            create(name: name, code: code, details: description, location: location, interests:interests);
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
