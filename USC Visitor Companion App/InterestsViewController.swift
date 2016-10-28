//
//  InterestsViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

protocol InterestsViewDelegates {
    func userDidSave(interestsArray: [String])
}

class InterestsViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    var interests: [String] = [String]()
    var fromAdmin: Bool?
    var interestDelegate: InterestsViewDelegates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        
        saveButton.isEnabled = false
        saveButton.title = ""
        
        if fromAdmin! {
            saveButton.isEnabled = true
            saveButton.title = "Save"
        }
        //get all locations from wrapper class
        interests = InterestsData.shared.interestNames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        if let delegate = self.interestDelegate {
            delegate.userDidSave(interestsArray: interests)
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if fromAdmin! {
//            if segue.identifier == "interests_to_admin" {
//                let destinationVC:AdminTableViewController = segue.destination as! AdminTableViewController
//                destinationVC.mInterestsArray = interests
//            }
//        }
//        if (segue.identifier == "admin_one") {
//            print("inside segue interests")
//            //get a reference to the destination view controller
//            let destinationVC:AdminTableViewController = segue.destination as! AdminTableViewController
//            
//            destinationVC.mInterestsArray = interests
//            for i in (0..<interests.count) {
//                print(interests[i])
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return interests.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = interests[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        let cell = tableView.cellForRow(at: indexPath)
        interests.append((cell?.textLabel?.text)!)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none

    }
}
