//
//  NearbyController.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-05-06.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class NearbyController: UIViewController{
    
    // MARK: Properties.
    fileprivate var profiles = [Profile]()
    
    // MARK: IBOutlets.
    @IBOutlet fileprivate var collectionView: UICollectionView!
    
    // MARK: Initialization.
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    // MARK: Loading.
    fileprivate func load(){
        Database.database().reference().child("Users").observeSingleEvent(of: .value) { snapashot in
            var profiles = [Profile]()
            for child in snapashot.children{
                guard let child = child as? DataSnapshot,
                      let profile = Profile(snapshot: child) else{ continue }
                profiles.append(profile)
            }
            self.profiles = profiles
            self.collectionView.reloadData()
        }
    }
}

// MARK: -
extension NearbyController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyCell", for: indexPath) as! NearbyCell
        let profile = profiles[indexPath.row]
        cell.setData(profile: profile)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = UIScreen.main.bounds.width/3 - 20
        let size = CGSize(width: dimension, height: dimension+20)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProfilePreviewController", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! ProfilePreviewController
        navigationController?.pushViewController(controller, animated: true)
        let profile = profiles[indexPath.row]
        controller.profile = profile
    }
}
