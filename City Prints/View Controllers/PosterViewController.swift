//
//  PosterViewController.swift
//  City Prints
//
//  Created by Terence Williams on 5/22/21.
//

import UIKit
import MapKit
import DTOverlayController

class PosterViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLbel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var labelContainer: UIView!
    
    var posterImage: UIImage!
    var placemark: MKPlacemark!
    var state: String?
    var country: String?
    var coordinates: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLabels(_fromMenu:)),
                                               name: .didUpdateLabels,
                                               object: nil)
    }

    func setupUI() {
        posterImageView.image = posterImage
   
        primaryLabel.text = placemark.name!.uppercased()
        primaryLabel.addCharacterSpacing()

        subtitleLabel.text = "29° 45' 37.5372'' N / 95° 22' 11.2944'' W"
        
        let dictionary: [String: Any] = placemark.value(forKey: "addressDictionary") as! [String : Any]
        if let state = dictionary["State"] {
            self.state = state as? String
        }
        if let country = dictionary["Country"] {
            self.country = country as? String
        }
        secondaryLbel.text = "\(state ?? "")  |  \(country ?? "")".uppercased()

        subtitleLabel.text = "\(round(placemark.coordinate.longitude * 10000) / 10000.0)  /  \( round(placemark.coordinate.latitude * 10000) / 10000)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didSelectLabelView))
        tap.numberOfTapsRequired = 1
        self.labelContainer.addGestureRecognizer(tap)
    }
    
    @objc func updateLabels(_fromMenu notification: NSNotification) {
        if let title = notification.userInfo?["title"] as? String {
            primaryLabel.text = title.uppercased()
        }
        if let subtitle = notification.userInfo?["subtitle"] as? String {
            secondaryLbel.text = subtitle
        }
        if let description = notification.userInfo?["description"] as? String {
            subtitleLabel.text = description
        }
    }
    
    //MARK: - Actions
    func takeScreenshot() {
        var screenshotImage :UIImage?
        let layer = self.view.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        let context = UIGraphicsGetCurrentContext()
        layer.render(in:context!)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    @IBAction func save() {
        takeScreenshot()
    }
    
    @IBAction func editLabels() {
        let editPosterViewController = EditPosterViewController()
        editPosterViewController.titleString = primaryLabel.text ?? ""
        editPosterViewController.subtitleString = secondaryLbel.text ?? ""
        editPosterViewController.descriptionString = subtitleLabel.text ?? ""
        
        let overlayController = DTOverlayController(viewController: editPosterViewController)
        overlayController.overlayHeight = .dynamic(0.85)
        overlayController.isPanGestureEnabled = false
        present(overlayController, animated: true, completion: nil)
    }
    
    @objc func didSelectLabelView() {
        editLabels()
    }
}
