//
//  MapViewController.swift
//  USC Visitor Companion App
//
//  Created by Jessica Pak on 9/24/16.
//  Copyright © 2016 University of Southern California. All rights reserved.
//

import UIKit
import GoogleMaps
import Parse
import BubbleTransition

class MapViewController: UIViewController, GMSMapViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    let bubbleTransition: BubbleTransition = BubbleTransition()
    var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
        }
    }
    var searchResults: [Location] = [Location]()
    
    
    // MARK: IBOutlets
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
        }
    }
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            self.searchTableView.delegate = self
            self.searchTableView.dataSource = self
            self.searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Search Cell")
        }
    }
    @IBOutlet weak var menuButton: UIButton!
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showMap()
        self.showLocationsOnMap()
        self.addSearchTableView()
    }
    
    
    // MARK: Map View Methods
    func showMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 34.020496, longitude: -118.285317, zoom: 20.0)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.view.insertSubview(self.mapView, at: 0)
    }
    
    func showLocationsOnMap() {
        for location in LocationData.shared.locations {
            let marker = GMSMarker()
            marker.map = self.mapView
            marker.title = location.name
            marker.snippet = location.details
            marker.position = (location.location?.coordinate)!
        }
    }
    
    
    // MARK: Search Methods
    func addSearchTableView() {
        self.searchTableView.isHidden = true
        self.view.insertSubview(self.searchTableView, aboveSubview: self.mapView)
        self.view.insertSubview(self.searchTableView, aboveSubview: self.menuButton)
    }
    
    func showSearch() {
        self.searchResults = LocationData.shared.locations(withPrefix: self.searchBar.text!)
        self.searchTableView.reloadData()
        self.searchTableView.isHidden = false
        self.searchBar.showsCancelButton = true
    }
    
    func hideSearch() {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        self.searchTableView.isHidden = true
    }
    
    
    // MARK: UISearchBarDelegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.showSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.showSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hideSearch()
    }
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideSearch()
        let location = self.searchResults[indexPath.row]
        let coordinate = location.location?.coordinate
        if let coordinate = coordinate {
            self.mapView.animate(toZoom: 20.0)
            self.mapView.animate(toLocation: coordinate)
        }
        self.searchTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: UITableViewDataSourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "Search Cell") as! SearchTableViewCell
        let location = self.searchResults[indexPath.row]
        cell.nameLabel.text = location.name
        cell.codeLabel.text = location.code
        cell.interestsLabel.text = location.interests?.joined(separator: ", ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableViewCell.defaultHeight
    }

    
    // MARK: GMSMapViewDelegate Methods
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "CheckInScreenSegue", sender: self)
    }
    
    
    // MARK: Storyboard Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Menu" {
            let MVC = segue.destination as! MenuViewController
            MVC.transitioningDelegate = self
            MVC.modalPresentationStyle = .custom
        }
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate Methods
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .present
        self.bubbleTransition.startingPoint = self.menuButton.center
        self.bubbleTransition.bubbleColor = UIColor.init(white: 0.9, alpha: 0.8)
        return self.bubbleTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .dismiss
        self.bubbleTransition.startingPoint = self.menuButton.center
        self.bubbleTransition.bubbleColor = UIColor.blue
        return self.bubbleTransition
    }

}
