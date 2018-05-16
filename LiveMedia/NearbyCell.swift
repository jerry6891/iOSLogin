//
//  NearbyCell.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-05-07.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class NearbyCell: UICollectionViewCell{
    
    override var bounds: CGRect{
        didSet{
            self.layoutIfNeeded()
        }
    }
    
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var labelCell: UILabel!
    
    func setData(profile: Profile){
        self.labelCell.text = profile.username
        
        if let absoluteUrl = profile.url, let url = URL(string: absoluteUrl){
         self.imageView.kf.setImage(with: url)
        }
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
}
