//
//  MapZoomLevelCollectionViewCell.swift
//  City Prints
//
//  Created by Terence Williams on 5/24/21.
//

import UIKit

class MapZoomLevelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

}
