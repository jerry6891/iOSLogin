//
//  Profile.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-05-07.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class Profile{
    var username: String?
    var age: String?
    var url: String?
    var about: String?
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else{ return nil }
        self.username = value["username"] as? String
        self.age = value["age"] as? String
        self.url = value["url"] as? String
        self.about = value["about"] as? String
    }
}
