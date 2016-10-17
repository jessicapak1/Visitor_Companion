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
import CoreLocation
import BetterSegmentedControl


class MapViewController: UIViewController, GMSMapViewDelegate, UIViewControllerTransitioningDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: Properties
    let bubbleTransition: BubbleTransition = BubbleTransition()
    
    var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
        }
    }
    
    var markers: [String: GMSMarker] = [String: GMSMarker]()
    
    var searchResults: [Location] = [Location]()
    
    
    // MARK: IBOutlets
    @IBOutlet weak var segmentedControl: BetterSegmentedControl! {
        didSet {
            self.segmentedControl.titleFont = .systemFont(ofSize: 16.0)
            self.segmentedControl.selectedTitleFont = .systemFont(ofSize: 16.0)
            self.segmentedControl.titles = ["General", "Interest", "Food", "Search"]
            self.segmentedControl.addTarget(self, action: #selector(MapViewController.segmentedControlValueChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            self.searchTableView.delegate = self
            self.searchTableView.dataSource = self
            self.searchTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "Search Result Cell")
            self.searchTableView.register(UINib(nibName: "NoResultsFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "No Results Found Cell")
            self.searchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    // MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "viterbi"))
        self.showMap()
        self.showMarkers()
        self.addSearch()
    }
    
    
    // MARK: Segmented Control Methods
    func segmentedControlValueChanged() {
        // clear all old locations
        if self.segmentedControl.index == 0 { // General
            // show locations with General interest from InterestData
        } else if self.segmentedControl.index == 1 { // Interest
            // show locations with User.current.interest from InterestData
        } else if self.segmentedControl.index == 2 { // Food
            // show locations with Food interets from InterestData
        } else if self.segmentedControl.index == 3 { // Search
            self.showSearch()
            do { try self.segmentedControl.set(index: 0, animated: true) } catch { } // should be set to the segment of the location
        }
    }
    
    
    // MARK: Map Methods
    func showMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 34.020496, longitude: -118.285317, zoom: 20.0, bearing: 30, viewingAngle: 90.0)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.view.insertSubview(self.mapView, at: 0)
      
        let locationManager = CLLocationManager()
        // request authorization from the user
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        print("locations = \(userLocation.coordinate.latitude) \(userLocation.coordinate.longitude)")
    }
    
    func showMarkers() {
        //create custom marker icons
        let foodImage = UIImage(named: "food")!.withRenderingMode(.alwaysTemplate)
        let foodView = UIImageView(image: foodImage)
        foodView.tintColor = UIColor(displayP3Red: 99.0/255.0, green: 00.0/255.0, blue: 00.0/255.0, alpha: 1.0)
        let libraryImage = UIImage(named: "library")!.withRenderingMode(.alwaysTemplate)
        let libraryView = UIImageView(image: libraryImage)
        libraryView.tintColor = UIColor(displayP3Red: 99.0/255.0, green: 00.0/255.0, blue: 00.0/255.0, alpha: 1.0)
        let buildingImage = UIImage(named: "building")!.withRenderingMode(.alwaysTemplate)
        let buildingView = UIImageView(image: buildingImage)
        buildingView.tintColor = UIColor(displayP3Red: 99.0/255.0, green: 00.0/255.0, blue: 00.0/255.0, alpha: 1.0)
        let fountainImage = UIImage(named: "fountain")!.withRenderingMode(.alwaysTemplate)
        let fountainView = UIImageView(image: fountainImage)
        fountainView.tintColor = UIColor(displayP3Red: 99.0/255.0, green: 00.0/255.0, blue: 00.0/255.0, alpha: 1.0)
        let fieldImage = UIImage(named: "field")!.withRenderingMode(.alwaysTemplate)
        let fieldView = UIImageView(image: fieldImage)
        fieldView.tintColor = UIColor(displayP3Red: 99.0/255.0, green: 00.0/255.0, blue: 00.0/255.0, alpha: 1.0)
        
        // create each marker
        for location in LocationData.shared.locations {
            let marker = GMSMarker()
            marker.map = self.mapView
            marker.title = location.name
            marker.snippet = location.details
            marker.position = (location.location?.coordinate)!
            
            switch (location.locType){
                
            case "food"?:
                marker.iconView = foodView
                break
                
            case "library"?:
                marker.iconView = libraryView
                break
                
            case "building"?:
                marker.iconView = buildingView
                break
                
            case "fountain"?:
                marker.iconView = fountainView
                break
                
            case "field"?:
                marker.iconView = fieldView
                break
                
            default:
                marker.icon = GMSMarker.markerImage(with: UIColor(red: 153.0, green: 0.0, blue: 0.0, alpha: 1.0))
            }
            
            self.markers[location.name!] = marker
        }
        
        
    }
    
    func animate(toLocation location: Location) {
        let coordinate = location.location?.coordinate
        if let coordinate = coordinate {
            self.mapView.animate(toZoom: 20.0)
            self.mapView.animate(toLocation: coordinate)
        }
    }
    
    func showInformation(forLocation location: Location) {
        self.mapView.selectedMarker = self.markers[location.name!]
    }
    
    
    // MARK: Search Methods
    func addSearch() {
        self.searchBar.isHidden = true
        self.searchTableView.isHidden = true
        self.view.bringSubview(toFront: self.searchTableView)
    }
    
    func showSearch() {
        // show the search bar and search results
        self.searchBar.becomeFirstResponder()
        self.searchBar.isHidden = false
        self.searchTableView.isHidden = false
        // show the results for the current search text
        self.searchResults = LocationData.shared.locations(withKeyword: self.searchBar.text!)
        self.searchTableView.reloadData()
    }
    
    func hideSearch() {
        // hide the search bar and search results
        self.searchBar.resignFirstResponder()
        self.searchBar.isHidden = true
        self.searchTableView.isHidden = true
        // reset the current search text
        self.searchBar.text = ""
    }
    
    
    // MARK: Storyboard Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Menu" {
            let NVC = segue.destination as! UINavigationController
            NVC.transitioningDelegate = self
            NVC.modalPresentationStyle = .custom
        }
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
        self.animate(toLocation: location)
        self.showInformation(forLocation: location)
        self.searchTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    
    // MARK: UITableViewDataSourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResults.count == 0 {
            return 1 // no results found table view cell
        }
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchResults.count == 0 {
            return self.configureNoResultsFoundCell()
        }
        let location = self.searchResults[indexPath.row]
        return self.configureSearchResultCell(withLocation: location)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchResultTableViewCell.defaultHeight
    }
    
    func configureNoResultsFoundCell() -> UITableViewCell {
        let noResultsFoundCell = self.searchTableView.dequeueReusableCell(withIdentifier: "No Results Found Cell") as! NoResultsFoundTableViewCell
        return noResultsFoundCell
    }
    
    func configureSearchResultCell(withLocation location: Location) -> UITableViewCell {
        let searchResultCell = self.searchTableView.dequeueReusableCell(withIdentifier: "Search Result Cell") as! SearchResultTableViewCell
        searchResultCell.nameLabel.text = location.name
        searchResultCell.codeLabel.text = location.code
        searchResultCell.interestsLabel.text = location.interests?.joined(separator: ", ")
        return searchResultCell
    }

    
    // MARK: GMSMapViewDelegate Methods
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "Show Location", sender: self)
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate Methods
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.duration = 0.25
        self.bubbleTransition.transitionMode = .present
        self.bubbleTransition.startingPoint = self.menuButton.center
        self.bubbleTransition.bubbleColor = .white
        return self.bubbleTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .dismiss
        return self.bubbleTransition
    }
    
    
    // MARK: IBAction Methods
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let location = mapView.myLocation
        if (location != nil) {
            mapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    

}
