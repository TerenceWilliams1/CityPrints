//
//  MapStyleURLCollectionViewCell.swift
//  City Prints
//
//  Created by Terence Williams on 5/19/21.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxDirections
import MapboxNavigation

class MapStyleURLCollectionViewCell: UICollectionViewCell, MGLMapViewDelegate {
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var mapView: NavigationMapView!
    var styleURL: MapStyleURL?

    var locationLongitude: Float = -95.368143 {
        didSet {}
    }
    var locationLatitude: Float = 29.760680 {
        didSet {}
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupMap()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        styleURL = nil
        titleLabel.text = nil
    }
    
    //MARK: - Setup View
    func setupMap() {
        mapView = NavigationMapView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: self.mapContainer.frame.width,
                                                  height: self.mapContainer.frame.height))
        mapView.tintColor = self.tintColor
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.setUserTrackingMode(.followWithHeading, animated: true, completionHandler: nil)
        mapView.showsUserHeadingIndicator = false
        mapView.isUserInteractionEnabled = false

        mapView.setCenter(CLLocationCoordinate2D.init(latitude: CLLocationDegrees(locationLatitude),
                                                      longitude: CLLocationDegrees(locationLongitude)),
                          zoomLevel: 10,
                          animated: false)
        
        mapContainer.addSubview(mapView)
        
        mapView.clipsToBounds = true
        mapContainer.layer.cornerRadius = 2
    }
}
