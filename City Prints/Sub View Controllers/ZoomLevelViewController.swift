//
//  ZoomLevelViewController.swift
//  City Prints
//
//  Created by Terence Williams on 5/24/21.
//

import UIKit

class ZoomLevelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!

    var zoomLevel: MapZoomLevel = .x1
    var zoomLevels: [MapZoomLevel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupData() {
        let mapZoomLevelZip = UINib(nibName: "MapZoomLevelCollectionViewCell", bundle: nil)
        collectionView.register(mapZoomLevelZip, forCellWithReuseIdentifier: "MapZoomLevelCollectionViewCell")
        
        zoomLevels = [.x1, .x2, .x3]
    }
    
    //MARK: - Actions
    @IBAction func changeMapZoomLevel() {
        let mapDataDict:[String: MapZoomLevel] = ["zoomLevel": zoomLevel]
        NotificationCenter.default.post(name: .didUpdateZoomLevel, object: nil, userInfo: mapDataDict)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zoomLevels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapZoomLevelCollectionViewCell", for: indexPath) as? MapZoomLevelCollectionViewCell
        
        let selectedZoomLevel = zoomLevels[indexPath.row]
        cell?.titleLabel.text = MapStyleHelper.title(_forZoomLevel: selectedZoomLevel)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedZoomLevel = zoomLevels[indexPath.row]
        zoomLevel = selectedZoomLevel
        self.changeMapZoomLevel()
    }
}
