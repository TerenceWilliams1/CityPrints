//
//  MapEditorDrawerController.swift
//  City Prints
//
//  Created by Terence Williams on 5/19/21.
//

import UIKit

class MapEditorDrawerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    var mapStyleURL: MapStyleURL = .redBull
    var styleURLs: [MapStyleURL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupData() {
        let mapStyleCellNib = UINib(nibName: "MapStyleURLCollectionViewCell", bundle: nil)
        collectionView.register(mapStyleCellNib, forCellWithReuseIdentifier: "MapStyleURLCollectionViewCell")
        
        styleURLs = [.orangeHighlight, .redBull, .frost, .redBull, .orangeHighlight, .frost, .redBull, .orangeHighlight, .redBull, .frost]
    }

    //MARK: - Actions
    @IBAction func changeMapStyle() {
        let mapDataDict:[String: MapStyleURL] = ["styleURL": mapStyleURL]
        NotificationCenter.default.post(name: .updateMapStyle, object: nil, userInfo: mapDataDict)

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapStyleURLCollectionViewCell", for: indexPath) as? MapStyleURLCollectionViewCell
        
        let selectedStyle = styleURLs[indexPath.row]
        cell?.mapView.styleURL = NSURL(string: selectedStyle.rawValue ) as URL?
        cell?.titleLabel.text = MapStyleHelper.title(_forStyleURL: selectedStyle)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedURL = styleURLs[indexPath.row]
        mapStyleURL = selectedURL
        self.changeMapStyle()
    }
}
