//
//  ProfilePreviewController.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-05-07.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class ProfilePreviewController: UIViewController{
    
    // Mark: Saved Profile Tapped
    @IBAction func savedProfileTapped(_ sender: UIBarButtonItem) {
    }
    
    // MARK: Profile Preview IBOutlets
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet var aboutTextView: UITextView!
    var profile: Profile?
    @IBOutlet var ageLabel: UILabel!
    
    // MARK: Profile Preview ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.title = "User Profile"
        self.title = profile?.username
        // nameField.text = profile?.username
        self.aboutTextView.text = profile?.about
        self.ageLabel.text = profile?.age
        if let absoluteUrl = profile?.url{
            let url = URL(string: absoluteUrl)
            self.profileImageView.kf.setImage(with: url)
        }
        profileImageView.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    }
}

    // Mark: Profile Preview Extension
    fileprivate extension ProfilePreviewController{
        
    }

