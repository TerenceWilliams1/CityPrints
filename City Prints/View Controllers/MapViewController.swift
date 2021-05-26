//
//  MapViewController.swift
//  City Prints
//
//  Created by Terence Williams on 4/26/21.
//

import UIKit
import MapKit
import Mapbox
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation
import DrawerView
import DTOverlayController

class MapViewController: UIViewController, MGLMapViewDelegate {
        
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var colorSchemeButton: UIButton!
    @IBOutlet weak var zoomLevelButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var mapView: NavigationMapView!
    var placemark: MKPlacemark!
    var styleURL: MapStyleURL! = .orangeHighlight
    var mapZoomLevel: MapZoomLevel! = .x1
    var annotation = MGLPointAnnotation()
    var loadingView: UIActivityIndicatorView!

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        subscribeNotifications()
        
        self.title = placemark.name
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.addAnnotation(annotation)
        menuContainer.isHidden = false
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    //MARK: - Setup View
    func setupMap() {
        mapView = NavigationMapView(frame: CGRect(x: 0,
                                                  y: 10,
                                                  width: self.view.frame.width - 12,
                                                  height: self.view.frame.height))
        mapView.tintColor = self.view.tintColor
        mapView.delegate = self
        mapView.backgroundColor = .white
        mapView.showsUserLocation = false
        mapView.showsUserHeadingIndicator = false
        updateMapStyle()

        mapView.setCenter(CLLocationCoordinate2D.init(latitude: CLLocationDegrees(placemark.coordinate.latitude),
                                                      longitude: CLLocationDegrees(placemark.coordinate.longitude)),
                          zoomLevel: mapZoomLevel.rawValue,
                          animated: false)
        
        self.view.addSubview(mapView)
        self.view.addSubview(bottomView)
        mapView.center.x = self.view.center.x
        
        annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(placemark.coordinate.latitude),
                                                       longitude: CLLocationDegrees(placemark.coordinate.longitude))
        annotation.title = placemark.name
        mapView.addAnnotation(annotation)
        
        self.view.addSubview(menuContainer)
        continueButton.layer.cornerRadius =  continueButton.frame.width / 2
        colorSchemeButton.layer.cornerRadius = colorSchemeButton.frame.width / 2
        zoomLevelButton.layer.cornerRadius = zoomLevelButton.frame.width / 2
        
        loadingView = UIActivityIndicatorView(style: .medium)
        loadingView.tintColor = .black
        let loadingBarButton = UIBarButtonItem(customView: loadingView)
        self.navigationItem.rightBarButtonItem = loadingBarButton
        loadingView.isHidden = true
    }
    
    func subscribeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMapStyle(_fromMenu:)),
                                               name: .updateMapStyle,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateZoomLevel(_fromMenu:)),
                                               name: .didUpdateZoomLevel,
                                               object: nil)
    }
    
    //MARK: - Update UI
    func updateMapStyle() {
        mapView.styleURL = NSURL(string: styleURL.rawValue) as URL?
    }
    
    func updateMapZoomLevel() {
        mapView.setCenter(CLLocationCoordinate2D.init(latitude: CLLocationDegrees(placemark.coordinate.latitude),
                                                      longitude: CLLocationDegrees(placemark.coordinate.longitude)),
                          zoomLevel: mapZoomLevel.rawValue,
                          animated: true)
    }
    
    @objc func updateMapStyle(_fromMenu notification: NSNotification) {
        if let url = notification.userInfo?["styleURL"] as? MapStyleURL {
            styleURL = url
            updateMapStyle()
        }
    }
    
    @objc func updateZoomLevel(_fromMenu notification: NSNotification) {
        if let zoomLevel = notification.userInfo?["zoomLevel"] as? MapZoomLevel {
            mapZoomLevel = MapZoomLevel(rawValue: zoomLevel.rawValue)
            updateMapZoomLevel()
        }
    }
    
    //MARK: - Actions
    @IBAction func openCustomizer() {
        let mapEditorViewController = MapEditorDrawerController()
        let overlayController = DTOverlayController(viewController: mapEditorViewController)
        overlayController.overlayHeight = .dynamic(0.8)
        overlayController.isPanGestureEnabled = false
        present(overlayController, animated: true, completion: nil)
    }
    
    @IBAction func openZoomLevels() {
        let zoomLevelViewController = ZoomLevelViewController()
        let overlayController = DTOverlayController(viewController: zoomLevelViewController)
        overlayController.overlayHeight = .dynamic(0.4)
        overlayController.isPanGestureEnabled = true
        present(overlayController, animated: true, completion: nil)
    }
    
    @IBAction func saveAndContinue() {
        loadingView.isHidden = false
        loadingView.startAnimating()
        
        menuContainer.isHidden = true
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
            mapView.reloadInputViews()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let renderer = UIGraphicsImageRenderer(size: self.view.bounds.size)
            let image = renderer.image { ctx in
                self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
            }
            
            self.continueButton.isHidden = false
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let posterViewController = storyBoard.instantiateViewController(withIdentifier: "PosterViewController") as! PosterViewController
            posterViewController.posterImage = image
            posterViewController.placemark = self.placemark
            self.navigationController?.pushViewController(posterViewController, animated: true)
        }
    }
}
