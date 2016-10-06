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
        }
    }
    
    var markers: [String: GMSMarker] = [String: GMSMarker]()
    
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
            self.searchTableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "Search Result Cell")
            self.searchTableView.register(UINib(nibName: "NoResultsFoundTableViewCell", bundle: nil), forCellReuseIdentifier: "No Results Found Cell")
            self.searchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    // MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showMap()
        self.showMarkers()
        self.addSearch()
    }
    
    
    // MARK: Map Methods
    func showMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 34.020496, longitude: -118.285317, zoom: 20.0)
        self.mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        self.view.insertSubview(self.mapView, at: 0)
    }
    
    func showMarkers() {
        for location in LocationData.shared.locations {
            let marker = GMSMarker()
            marker.map = self.mapView
            marker.title = location.name
            marker.snippet = location.details
            marker.position = (location.location?.coordinate)!
            marker.icon = GMSMarker.markerImage(with: UIColor(red: 153.0, green: 0.0, blue: 0.0, alpha: 1.0))
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
        self.searchTableView.isHidden = true
        self.view.insertSubview(self.searchTableView, aboveSubview: self.mapView)
        self.view.insertSubview(self.searchTableView, aboveSubview: self.menuButton)
    }
    
    func showSearch() {
        self.searchResults = LocationData.shared.locations(withKeyword: self.searchBar.text!)
        self.searchTableView.reloadData()
        self.searchTableView.isHidden = false
        self.searchBar.showsCancelButton = true
    }
    
    func hideSearch() {
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        self.searchTableView.isHidden = true
    }
    
    
    // MARK: Storyboard Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Menu" {
            let MVC = segue.destination as! MenuViewController
            MVC.transitioningDelegate = self
            MVC.modalPresentationStyle = .custom
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
        self.performSegue(withIdentifier: "CheckInScreenSegue", sender: self)
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate Methods
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.duration = 0.25
        self.bubbleTransition.transitionMode = .present
        self.bubbleTransition.startingPoint = self.menuButton.center
        self.bubbleTransition.bubbleColor = UIColor.init(white: 0.9, alpha: 0.9)
        return self.bubbleTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .dismiss
        return self.bubbleTransition
    }

}
