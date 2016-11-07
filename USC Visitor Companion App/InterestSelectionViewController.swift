//
//  InterestSelectionViewController.swift
//  USC Visitor Companion App
//
//  Created by Christian Villa on 11/3/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit

class InterestSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    var interests: [String] = InterestsData.shared.interestNames()
    
    var currentInterest: String = User.current.interest!
    
    
    // MARK: IBOutlets
    @IBOutlet weak var interestTableView: UITableView! {
        didSet {
            self.interestTableView.delegate = self
            self.interestTableView.dataSource = self
            self.interestTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.interestTableView.deselectRow(at: indexPath, animated: true)
        self.currentInterest = self.interests[indexPath.row]
        self.interestTableView.reloadData()
    }
    
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let interestCell = self.interestTableView.dequeueReusableCell(withIdentifier: "Interest Cell")
        interestCell?.textLabel?.text = self.interests[indexPath.row]
        interestCell?.accessoryType = (self.interests[indexPath.row] == self.currentInterest) ? .checkmark : .none
        return interestCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    // MARK: IBAction Methods
    @IBAction func closeButtonPressed() {
        User.current.interest = self.currentInterest
        self.dismiss(animated: true, completion: nil)
    }
    
}
