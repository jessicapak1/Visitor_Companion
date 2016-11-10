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

protocol MapViewDelegates {
    func userDidSaveMap(newLocation: CLLocation)
}

class MapViewController: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // MARK: Properties
    var mapDelegate: MapViewDelegates?
    var mapView: GMSMapView! {
        didSet {
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
        }
    }
    var markers: [String: GMSMarker] = [String: GMSMarker]()
    var currentLocation = [Location]()
    var currentMarker = GMSMarker()
    let locationManager = CLLocationManager()
    var newMarker: Bool = false
    
    let customMapStyle = "[" +
        "  {" +
        "    \"featureType\": \"poi\"," +
        "    \"elementType\": \"all\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"visibility\": \"off\"" +
        "      }" +
        "    ]" +
        "  }," +
        "  {" +
        "    \"featureType\": \"transit\"," +
        "    \"elementType\": \"labels.icon\"," +
        "    \"stylers\": [" +
        "      {" +
        "        \"visibility\": \"off\"" +
        "      }" +
        "    ]" +
        "  }" +
    "]"
    
    var searchResults: [Location] = [Location]()
    var added_marker = GMSMarker()
    var fromAdmin : Bool?
    var newLocation: CLLocation?
    
    
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
            let resultFoundID = "ResultFoundTableViewCell"
            self.searchTableView.register(UINib(nibName: resultFoundID, bundle: nil), forCellReuseIdentifier: resultFoundID)
            let noResultFoundID = "NoResultsFoundTableViewCell"
            self.searchTableView.register(UINib(nibName: noResultFoundID, bundle: nil), forCellReuseIdentifier: noResultFoundID)
            self.searchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    
    // MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fromAdmin = false
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "viterbi"))
        self.addSearch()
        self.showMap()
        self.showMarkers(forLocations: LocationData.shared.locations)
    }
    
    
    // MARK: Map View Methods
    func showMap() {
        // configure the map view
        let camera = GMSCameraPosition.camera(withLatitude: 34.020496, longitude: -118.285317, zoom: 20.0, bearing: 30, viewingAngle: 90.0)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.mapView.mapStyle = try? GMSMapStyle(jsonString: self.customMapStyle)
        self.view.insertSubview(self.mapView, at: 0)
        
        // configure the location manager
        self.configureLocationManager()
        
        let circleCenter = locationManager.location?.coordinate
        if let circleCenter = circleCenter {
            let circ = GMSCircle(position: circleCenter, radius: 10)
            circ.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
            circ.strokeColor = UIColor.red
            circ.strokeWidth = 2
            circ.map = mapView
        }
    }
    
    func showMarkers(forLocations locations: [Location]) {
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
        for location in locations {
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
        // animate the map view to the specified location
        let coordinate = location.location?.coordinate
        if let coordinate = coordinate {
            self.mapView.animate(toZoom: 20.0)
            self.mapView.animate(toLocation: coordinate)
        }
    }
    
    func showInformation(forLocation location: Location) {
        // show the information dialog for the specified location
        self.mapView.selectedMarker = self.markers[location.name!]
    }
    
    
    // MARK: CLLocationManagerDelegate Methods
    func configureLocationManager() {
        // request authorization from the user to access their location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // change the colors of markers near the location of the user
        let userLocation = locations[0]
        let maxDistance = CLLocationDistance(30)
        for location in LocationData.shared.locations {
            let distance = userLocation.distance(from: location.location!)
            if distance < maxDistance {
                self.markers[location.name!]?.iconView?.tintColor = UIColor.blue
            } else {
                self.markers[location.name!]?.iconView?.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
            }
        }
    }
    
    
    // MARK: Search Methods
    func addSearch() {
        self.searchTableView.isHidden = true
        self.view.bringSubview(toFront: self.searchTableView)
    }
    
    func showSearchResults(forKeyword keyword: String) {
        // show the search results table view
        self.searchBar.showsCancelButton = true
        self.searchTableView.isHidden = false
        // show the search results for the search text
        self.searchResults = LocationData.shared.locations(withKeyword: keyword)
        self.searchTableView.reloadData()
    }
    
    func hideSearchResults() {
        // hide the search results table view
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.searchTableView.isHidden = true
        // reset the search text
        self.searchBar.text = ""
        self.searchTableView.reloadData()
    }
    
    
    // MARK: Storyboard Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Location" {
            let navVC = segue.destination as! UINavigationController
            let locationVC = navVC.viewControllers.first as! LocationTableViewController
            locationVC.name = currentMarker.title!
        }
        
        if fromAdmin! {
            if segue.identifier == "map_to_admin" {
                let destinationVC:AdminTableViewController = segue.destination as! AdminTableViewController
                destinationVC.addLocationValue = newLocation;
            }
        }
    }
    
    
    // MARK: UISearchBarDelegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.showSearchResults(forKeyword: self.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.showSearchResults(forKeyword: self.searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hideSearchResults()
    }
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTableView.deselectRow(at: indexPath, animated: true)
        self.hideSearchResults()
        let location = self.searchResults[indexPath.row]
        self.animate(toLocation: location)
        self.showInformation(forLocation: location)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.searchBar.isFirstResponder == true {
            self.searchBar.resignFirstResponder()
            for view1 in self.searchBar.subviews {
                for view2 in view1.subviews {
                    if view2 is UIButton {
                        let button = view2 as! UIButton
                        button.isEnabled = true
                        button.isUserInteractionEnabled = true
                    }
                }
            }
        }
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
        return self.configureResultFoundCell(withLocation: location)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ResultFoundTableViewCell.defaultHeight
    }
    
    func configureNoResultsFoundCell() -> UITableViewCell {
        let noResultsFoundID = "NoResultsFoundTableViewCell"
        let noResultsFoundCell = self.searchTableView.dequeueReusableCell(withIdentifier: noResultsFoundID) as! NoResultsFoundTableViewCell
        return noResultsFoundCell
    }
    
    func configureResultFoundCell(withLocation location: Location) -> UITableViewCell {
        let resultFoundID = "ResultFoundTableViewCell"
        let resultFoundCell = self.searchTableView.dequeueReusableCell(withIdentifier: resultFoundID) as! ResultFoundTableViewCell
        resultFoundCell.nameLabel.text = location.name
        resultFoundCell.codeLabel.text = location.code
        resultFoundCell.interestsLabel.text = location.interests?.joined(separator: ", ")
        return resultFoundCell
    }

    
    // MARK: GMSMapViewDelegate Methods
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if newMarker == true {
            added_marker = marker;
            newLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
            if let delegate = self.mapDelegate {
                delegate.userDidSaveMap(newLocation: newLocation!)
            }
            self.dismiss(animated: true, completion: nil)
            newMarker = false
        }
        else{
            currentMarker = marker
            self.performSegue(withIdentifier: "Show Location", sender: self)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        newMarker = true
        let new_marker = GMSMarker()
        print("long press")
        new_marker.position = coordinate
        new_marker.map = self.mapView
        new_marker.title = "Click to save location"
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first! as! InfoWindow
        infoWindow.locationNameLabel.text = marker.title
        infoWindow.userInfoLabel.text = "User location info will go here."
        return infoWindow
    }
    
    
    // MARK: IBAction Methods
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let location = mapView.myLocation
        if (location != nil) {
            mapView.animate(toLocation: (location?.coordinate)!)
        }
    }

}
