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
    var filters: [String] = InterestsData.shared.interestNames()
    
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
    @IBOutlet weak var filterButton: UIButton! {
        didSet {
            // provide a negative shadow so that it doesn't interfere with the border
            self.filterButton.layer.shadowColor = UIColor.gray.cgColor
            self.filterButton.layer.shadowOffset = CGSize(width: -1.0, height: 1.5)
            self.filterButton.layer.shadowOpacity = 1.0
            self.filterButton.layer.shadowRadius = 2.0
            
            self.filterButton.layer.borderWidth = 0.25
            self.filterButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var searchButton: ShadowButton! {
        didSet {
            self.searchButton.addShadow()
            
            self.searchButton.layer.borderWidth = 0.25
            self.searchButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var filterTableView: UITableView! {
        didSet {
            self.filterTableView.delegate = self
            self.filterTableView.dataSource = self
            self.filterTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var shadowButton: UIButton!
    
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
    
    @IBOutlet weak var campusLocationButton: ShadowButton! {
        didSet {
            self.campusLocationButton.addShadow()
        }
    }
    
    @IBOutlet weak var currentLocationButton: ShadowButton! {
        didSet {
            self.currentLocationButton.addShadow()
        }
    }
    
    @IBOutlet weak var settingsButtonItem: UIBarButtonItem!
    
    // MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fromAdmin = false
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "viterbi"))
        self.addFilters()
        self.addSearch()
        self.showMap()
        self.showMarkers(forLocations: LocationData.shared.locations)
        
        /*
        // MARK: tutorial code goes here
        let defaults = UserDefaults.standard
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
        }
         */
    
    }
    
    
    // MARK: Map View Methods
    func showMap() {
        // configure the map view
        let camera = GMSCameraPosition.camera(withLatitude: 34.021044, longitude: -118.285798, zoom: 15.35)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.mapView.mapStyle = try? GMSMapStyle(jsonString: self.customMapStyle)
        self.view.insertSubview(self.mapView, at: 0)
        
        // configure the location manager
        self.configureLocationManager()
    }
    
    func showMarkers(forLocations locations: [Location]) {
        self.mapView.clear()
        
        //create custom marker icons
        let foodImage = UIImage(named: "food")!.withRenderingMode(.alwaysTemplate)
        let foodView = UIImageView(image: foodImage)
        foodView.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        let libraryImage = UIImage(named: "library")!.withRenderingMode(.alwaysTemplate)
        let libraryView = UIImageView(image: libraryImage)
        libraryView.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        let buildingImage = UIImage(named: "building")!.withRenderingMode(.alwaysTemplate)
        let buildingView = UIImageView(image: buildingImage)
        buildingView.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        let fountainImage = UIImage(named: "fountain")!.withRenderingMode(.alwaysTemplate)
        let fountainView = UIImageView(image: fountainImage)
        fountainView.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        let fieldImage = UIImage(named: "field")!.withRenderingMode(.alwaysTemplate)
        let fieldView = UIImageView(image: fieldImage)
        fieldView.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        
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
                marker.icon = GMSMarker.markerImage(with: UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0))
            }
            
            self.markers[location.name!] = marker
        }
    }
    
    func animate(toLocation location: Location) {
        // animate the map view to the specified location
        let coordinate = location.location?.coordinate
        if let coordinate = coordinate {
            self.mapView.animate(toZoom: 18.0) // zoom can be customized to a more comfortable level
            self.mapView.animate(toLocation: coordinate)
        }
    }
    
    func showInformation(forLocation location: Location) {
        // show the info window for the specified location
        self.mapView.selectedMarker = self.markers[location.name!]
    }
    
    
    // MARK: CLLocationManagerDelegate Methods
    func configureLocationManager() {
        // request authorization from the user to access their location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        // configure the location manager to update whenever the user moves
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // higher accuracy = more battery usage
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
        self.hideFilters()
        
        // show the search results table view and bring it to the front
        self.searchTableView.isHidden = false
        self.searchBar.becomeFirstResponder()
        self.view.bringSubview(toFront: self.searchBar)

        // fetch the locations with names that contain the search text and reload the search results table view
        self.searchResults = LocationData.shared.locations(withKeyword: keyword)
        self.searchTableView.reloadData()
    }
    
    func hideSearchResults() {
        // hide the search results table view and bring it to the back
        self.searchTableView.isHidden = true
        self.searchBar.resignFirstResponder()
        self.view.sendSubview(toBack: self.searchBar)
        
        // reset the search text and reload the search results table view
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
    
    
    // MARK: Filter Methods
    func addFilters() {
        // configure the background shadow
        self.shadowButton.alpha = 0.0
        self.shadowButton.isHidden = true
        self.view.bringSubview(toFront: self.shadowButton)
        
        // configure the filter table view
        self.filterTableView.isHidden = true
        self.view.bringSubview(toFront: self.filterTableView)
        
        // reload the interests from the database in case they were not loaded correctly at start-up
        if self.filters.count == 0 {
            InterestsData.shared.fetchInterests()
            self.filters = InterestsData.shared.interestNames()
        }
    }
    
    func showFilters() {
        self.hideSearchResults()
        
        self.filterTableView.isHidden = false
        self.shadowButton.isHidden = false
        self.filterTableView.frame.origin.x = -(self.view.frame.size.width / 2)

        UIView.animate(withDuration: 0.18, delay: 0.0, options: .curveEaseIn, animations: {
            // animate the filter table view to fill up half of the screen and to slowly darken the background shadow
            self.filterTableView.frame.origin.x += self.view.frame.size.width / 2
            self.shadowButton.alpha = 1.0
        }, completion: nil)
    }
    
    func hideFilters() {
        UIView.animate(withDuration: 0.18, delay: 0.0, options: .curveEaseOut, animations: {
            // animate the filter table view to hide and the background shadow to clear up
            self.filterTableView.frame.origin.x -= self.view.frame.size.width / 2
            self.shadowButton.alpha = 0.0
        }, completion: {
            (succeeded) in
            self.filterTableView.isHidden = true
            self.shadowButton.isHidden = true
        })
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
        if tableView == self.searchTableView {
            // deselect the selected search result and hide the search results table view
            self.searchTableView.deselectRow(at: indexPath, animated: true)
            self.hideSearchResults()
            
            // fetch the selected location and show only that location on the map
            let location = self.searchResults[indexPath.row]
            self.showMarkers(forLocations: [location])
            
            // animate to the selected location and show its info window
            self.animate(toLocation: location)
            self.showInformation(forLocation: location)
            
            // reset the interest of the current user so that locations from the filter table view aren't shown
            User.current.interest = ""
            self.filterTableView.reloadData()
        } else if tableView == self.filterTableView {
            // fetch the locations tagged with the selected filter
            let locations = InterestsData.shared.interest(withName: self.filters[indexPath.row])?.locations
            
            // animate to show the whole campus then show the locations tagged with the selected filter
            if let locations = locations {
                self.campusLocationButtonPressed()
                self.showMarkers(forLocations: locations)
            }
            
            // set the interest of the current user to the selected filter
            User.current.interest = self.filters[indexPath.row]
            
            // reload the filter table view to highlight the selected filter then hide the filter table view
            self.filterTableView.reloadData()
            self.hideFilters()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.searchBar.isFirstResponder == true {
            self.searchBar.resignFirstResponder()
            // keep the cancel button enabled as they are searching
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
        if tableView == self.filterTableView {
            return self.filters.count
        } else if tableView == self.searchTableView {
            return self.searchResults.count == 0 ? 1 : self.searchResults.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchTableView {
            if self.searchResults.count == 0 {
                return self.configureNoResultsFoundCell()
            }
            return self.configureResultFoundCell(withLocation: self.searchResults[indexPath.row])
        } else if tableView == self.filterTableView {
            return self.configureFilterCell(withFilter: self.filters[indexPath.row], indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.searchTableView {
            return ResultFoundTableViewCell.defaultHeight
        } else if tableView == self.filterTableView {
            return 45.0
        }
        
        return 0.0
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
    
    func configureFilterCell(withFilter filter: String, indexPath: IndexPath) -> UITableViewCell {
        let filterID = "Filter Cell"
        let filterCell = self.filterTableView.dequeueReusableCell(withIdentifier: filterID)
        filterCell?.textLabel?.text = filter
        if filter == User.current.interest {
            self.filterTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return filterCell!
    }

    
    // MARK: GMSMapViewDelegate Methods
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.hideFilters()
        
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
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first! as! InfoWindow
        infoWindow.locationNameLabel.text = marker.title
        infoWindow.userInfoLabel.text = "User location info will go here."
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if let currentLocation = self.mapView.myLocation {
            let changedLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            if changedLocation.distance(from: currentLocation) > 5 {
                self.currentLocationButton.setImage(#imageLiteral(resourceName: "CurrentLocationInactive"), for: .normal)
            } else {
                self.currentLocationButton.setImage(#imageLiteral(resourceName: "CurrentLocationActive"), for: .normal)
            }
        }
    }
    
    
    // MARK: IBAction Methods
    @IBAction func campusLocationButtonPressed() {
        let location = CLLocation(latitude: 34.021044, longitude: -118.285798)
        self.mapView.animate(toLocation: location.coordinate)
        self.mapView.animate(toZoom: 15.35)
    }
    
    @IBAction func currentLocationButtonPressed() {
        if let currentLocation = self.mapView.myLocation {
            self.mapView.animate(toLocation: currentLocation.coordinate)
        }
        let tutorialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Annotation") as! AnnotationViewController
        tutorialViewController.alpha = 0.5
        present(tutorialViewController, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonPressed() {
        if self.filterTableView.isHidden {
            self.showFilters()
        } else {
            self.hideFilters()
        }
    }
    
    @IBAction func searchButtonPressed() {
        self.showSearchResults(forKeyword: self.searchBar.text!)
    }
    
    @IBAction func shadowButtonPressed() {
        self.hideFilters()
    }

}
