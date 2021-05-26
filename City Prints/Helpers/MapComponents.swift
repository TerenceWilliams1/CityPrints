//
//  MapComponents.swift
//  City Prints
//
//  Created by Terence Williams on 5/19/21.
//

import Foundation
import UIKit

class MapStyleHelper {

    //MARK: - Helpers
    static func title(_forStyleURL url: MapStyleURL) -> String {
        switch url {
        case .orangeHighlight:
            return "Midnight Storm"
        case .redBull:
            return "Redbull"
            
        case .frost:
            return "Frost"
        }
    }
    
    static func title(_forZoomLevel level: MapZoomLevel) -> String {
        switch level {
        case .x1:
            return "x1"
        case .x2:
            return "x2"
        case .x3:
            return "x3"
        }
    }
}

public enum MapStyleURL: String {
    case orangeHighlight = "mapbox://styles/terencewilliams1/ckot5czvz5y3t17p5s27ghe86"
    
    case redBull = "mapbox://styles/terencewilliams1/ckom603mq0b3s18q64bf9u7ka"
    
    case frost = "mapbox://styles/terencewilliams1/ckouz04ku1n4o17pe8zl900gq"
}

public enum MapZoomLevel: Double {
    case x1 = 10
    case x2 = 12.5
    case x3 = 15
}

public extension Notification.Name {
    static let updateMapStyle = Notification.Name(rawValue: "updateMapStyle")
    static let didSelectPlacemark = Notification.Name(rawValue: "didSelectPlacemark")
    static let didUpdateZoomLevel = Notification.Name(rawValue: "didUpdateZoomLevel")
    static let didUpdateLabels = Notification.Name(rawValue: "didUpdateLabels")
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: kernValue,
                                      range: NSRange(location: 0,
                                                     length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
