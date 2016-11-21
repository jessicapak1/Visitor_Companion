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

class MapViewController: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, SettingsTableViewControllerDelegate {
    
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
    var firstOpen: Bool = true
    
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
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.filterTableView.backgroundView = blurEffectView
            
            self.filterTableView.delegate = self
            self.filterTableView.dataSource = self
            self.filterTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var sideFilterButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            self.searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.searchTableView.backgroundView = blurEffectView
            
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
            self.campusLocationButton.layer.cornerRadius = 5.0
            self.campusLocationButton.addShadow()
        }
    }
    
    @IBOutlet weak var currentLocationButton: ShadowButton! {
        didSet {
            self.currentLocationButton.layer.cornerRadius = 5.0
            self.currentLocationButton.addShadow()
        }
    }
    
    @IBOutlet weak var dimensionButton: ShadowButton! {
        didSet {
            self.dimensionButton.layer.cornerRadius = 5.0
            self.dimensionButton.addShadow()
        }
    }
    
    @IBOutlet weak var settingsButtonItem: UIBarButtonItem!
    
    
    // MARK: View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fromAdmin = false
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "viterbi-yellow"))
        self.addFilters()
        self.addSearch()
        self.showMap()

        // MARK: tutorial code goes here
        let defaults = UserDefaults.standard
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            self.userDidStartTutorial()
        }
    
    }
    
    
    // MARK: Map View Methods
    func showMap() {
        
        // configure the location manager
        self.configureLocationManager()
        
        // configure the map view
        let camera = GMSCameraPosition.camera(withLatitude: 34.021044, longitude: -118.285798, zoom: 15.35)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.mapView.mapStyle = try? GMSMapStyle(jsonString: self.customMapStyle)
        self.view.insertSubview(self.mapView, at: 0)
        
    }
    
    func showMarkers(forLocations locations: [Location]) {
        //create custom marker icons
        let foodView = UIImageView(image: UIImage(named: "food"))
        
        let libraryView = UIImageView(image: UIImage(named: "library"))
        
        let buildingView = UIImageView(image: UIImage(named: "building"))
       
        let fountainView = UIImageView(image: UIImage(named: "fountain"))
        
        let fieldView = UIImageView(image: UIImage(named: "field"))
       
        let athleticsView = UIImageView(image: UIImage(named: "athletics"))
        
        let commercialView = UIImageView(image: UIImage(named: "commercial"))
        
        let otherView = UIImageView(image: UIImage(named: "other"))
        
        let parkingView = UIImageView(image: UIImage(named: "parking"))
        
        let residentialView = UIImageView(image: UIImage(named: "residential"))
        
        let computerlabView = UIImageView(image: UIImage(named: "computerLab"))
        
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
                
            case "athletics"?:
                marker.iconView = athleticsView
                break
                
            case "commercial"?:
                marker.iconView = commercialView
                break
                
            case "other"?:
                marker.iconView = otherView
                break
                
            case "parking"?:
                marker.iconView = parkingView
                break
                
            case "residential"?:
                marker.iconView = residentialView
                break
                
            case "computerLab"?:
                 marker.iconView = computerlabView
                 break

            default:
                break
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
    
    
    // MARK: SettingsTableViewControllerDelegate Methods
    func userDidStartTutorial() {
        let tutorialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Annotation") as! AnnotationViewController
        tutorialViewController.alpha = 0.5
        self.present(tutorialViewController, animated: true, completion: nil)
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
            self.locationManager.distanceFilter = 5
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // change the colors of markers near the location of the user
        
        if firstOpen {
            if let location = locations.first {
                mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
                
                showUSC(userLocation: location.coordinate)
                
            }
            
            firstOpen = false
        }
        
        for location in LocationData.shared.locations {
            if let userLocation = locations.last, let currentLocation = location.location {
                if userLocation.distance(from: currentLocation) < 30 {
                    let newView = UIImageView(image: UIImage(named: location.locType!))
                    //newView.tintColor = UIColor.blue
                    self.markers[location.name!]?.iconView = newView
                } else {
                    let oldView = UIImageView(image: UIImage(named: location.locType!))
                    //oldView.tintColor = UIColor(red: 153.0/255.0, green: 27.0/255.0, blue: 30.0/255.0, alpha: 1.0)
                    self.markers[location.name!]?.iconView = oldView
                }
            }
        }
    }
    
    func showUSC(userLocation: CLLocationCoordinate2D){
        
        let usc = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: 34.017707, longitude: -118.292653), coordinate: CLLocationCoordinate2D(latitude: 34.033343, longitude: -118.275356))
        if !usc.contains(userLocation) {
            let alert = UIAlertController(title: "Not at USC", message: "It looks like you are not near USC. Would you like to see USC's campus?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{ action in
                self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: 34.021776, longitude: -118.286342))
                self.mapView.animate(toZoom: 15.2)
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
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
            let maxDistance = CLLocationDistance(30)
            if (self.mapView.myLocation?.distance(from: CLLocation(latitude: currentMarker.position.latitude, longitude: currentMarker.position.longitude)))! < maxDistance {
                locationVC.closeProximity = true
            }
        } else if segue.identifier == "Show Settings" {
            let NVC = segue.destination as! UINavigationController
            let SVC = NVC.viewControllers.first as! SettingsTableViewController
            SVC.delegate = self
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
        // configure the filter table view
        self.filterTableView.isHidden = true
        self.view.bringSubview(toFront: self.filterTableView)
        
        self.sideFilterButton.isHidden = true
        self.view.bringSubview(toFront: self.sideFilterButton)
        
        // reload the interests from the database in case they were not loaded correctly at start-up
        if self.filters.count == 0 {
            InterestsData.shared.fetchInterests()
            self.filters = InterestsData.shared.interestNames()
        }
    }
    
    func showFilters() {
        self.hideSearchResults()
        
        self.filterTableView.isHidden = false
        self.filterTableView.frame.origin.x = -(self.view.frame.size.width / 2)
        
        self.sideFilterButton.isHidden = false

        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            // animate the filter table view to fill up half of the screen
            self.filterTableView.frame.origin.x += (self.view.frame.size.width / 2)
        }, completion: nil)
    }
    
    func hideFilters() {
        self.filterTableView.frame.origin.x = 0.0
        
        self.sideFilterButton.isHidden = true
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            // animate the filter table view to hide
            self.filterTableView.frame.origin.x -= (self.view.frame.size.width / 2)
        }, completion: {
            (succeeded) in
            self.filterTableView.isHidden = true
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
            self.mapView.clear()
            self.showMarkers(forLocations: [location])
            
            // animate to the selected location and show its info window
            self.animate(toLocation: location)
            self.showInformation(forLocation: location)
            
            // reset the interest of the current user so that locations from the filter table view aren't shown
            User.current.filters.removeAll()
            self.filterTableView.reloadData()
        } else if tableView == self.filterTableView {
            let filter = self.filters[indexPath.row]
            if User.current.filters.contains(filter) {
                User.current.filters.remove(at: User.current.filters.index(of: filter)!) // could be more optimized
                
                self.mapView.clear()
                
                for filter in User.current.filters {
                    // fetch the locations tagged with the selected filter
                    let locations = InterestsData.shared.interest(withName: filter)?.locations
                    
                    // animate to show the whole campus then show the locations tagged with the selected filter
                    if let locations = locations {
                        self.showMarkers(forLocations: locations)
                    }
                }
            } else {
                // set the filters of the current user to the selected filter
                User.current.filters.append(self.filters[indexPath.row])
                
                // fetch the locations tagged with the selected filter
                let locations = InterestsData.shared.interest(withName: filter)?.locations
                
                // animate to show the whole campus then show the locations tagged with the selected filter
                if let locations = locations {
                    self.showMarkers(forLocations: locations)
                }
            }
            
            // reload the filter table view to highlight the selected filters
            self.filterTableView.reloadData()
            self.campusLocationButtonPressed()
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
        filterCell?.accessoryType = User.current.filters.contains(filter) ? .checkmark : .none
        return filterCell!
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
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("InfoWindow", owner: self, options: nil)?.first! as! InfoWindow
        infoWindow.locationNameLabel.text = marker.title
        infoWindow.seeMoreButton.setTitle("See More", for: UIControlState.normal)
        infoWindow.layer.shadowColor = UIColor.lightGray.cgColor
        infoWindow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        infoWindow.layer.shadowOpacity = 1.0
        infoWindow.layer.shadowRadius = 2.0
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
    @IBAction func settingsButtonPressed() {
        self.performSegue(withIdentifier: "Show Settings", sender: nil)
    }
    
    @IBAction func campusLocationButtonPressed() {
        let location = CLLocation(latitude: 34.021044, longitude: -118.285798)
        self.mapView.animate(toLocation: location.coordinate)
        self.mapView.animate(toZoom: 15.35)
    }
    
    @IBAction func currentLocationButtonPressed() {
        if let currentLocation = self.mapView.myLocation {
            self.mapView.animate(toLocation: currentLocation.coordinate)
        }
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
    
    @IBAction func sideFilterButtonPressed() {
        self.hideFilters()
    }
    
    @IBAction func dimensionButtonPressed() {
        if self.dimensionButton.currentTitle == "3D" {
            self.mapView.animate(toViewingAngle: 90.0)
            self.dimensionButton.setTitle("2D", for: .normal)
        } else if self.dimensionButton.currentTitle == "2D" {
            self.mapView.animate(toViewingAngle: 0.0)
            self.dimensionButton.setTitle("3D", for: .normal)
        }
    }

}
