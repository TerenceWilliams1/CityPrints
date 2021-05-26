//
//  ViewController.swift
//  City Prints
//
//  Created by Terence Williams on 4/26/21.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectdPlacemark: MKPlacemark!
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getInfo(_fromNotification:)),
                                               name: .didSelectPlacemark,
                                               object: nil)
    }
    
    func setupUI() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        continueButton.layer.cornerRadius = 14
        continueButton.setTitle("Select a Location", for: .normal)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search a city, landmark, or address"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        searchBar.isHidden = true
        
        headerLabel.text = "Custom map designs that highlight your favorite places"
        headerLabel.textColor = .black
    }
    
    @objc func getInfo(_fromNotification notification: NSNotification) {
        if let placeemark = notification.userInfo?["placemark"] as? MKPlacemark {
            print(placeemark)
            self.selectdPlacemark = placeemark
            self.updateUI()
        }
    }
    
    func updateUI() {
        continueButton.setTitle("Create Map", for: .normal)
        searchBar.text = selectdPlacemark.name
        
        headerLabel.text = "Get started by customizing your map location, theme, & more"
        headerLabel.textColor = self.view.tintColor
    }
    
    @IBAction func continueWithLocation() {
        if (self.selectdPlacemark == nil) {
            searchBar.isHidden = false
            searchBar.becomeFirstResponder()
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapViewController.placemark = self.selectdPlacemark
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
}

extension HomeViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}
