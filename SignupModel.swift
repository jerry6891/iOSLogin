//
//  SignupModel.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-04-23.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class SignupModel {
    var photo: UIImage?
    func validate(data: [String: String]) -> Bool {
        guard let username = data["username"],
            let email = data["email"],
            let password = data["password"],
            let confirmpassword = data["confirmpassword"]
            else { return false }
        
        if password != confirmpassword {
            return false
        }
        if password.count < 6 {
            return false
        }
        if username.count < 6 {
            return false
        }
        if email.count < 6 {
            return false
        }
        
        return true
    }
    func authenticate(data:[String: String], completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: data["email"]!, password: data["password"]!, completion: {(user, error) in
                guard error == nil, let user = user else {
                // Bad.
                completion(error)
                return
            }
            var object: [String: String] = [:]
            object["email"] =  data["email"]
            object["username"] =  data["username"]
            Database.database()
                .reference()
                .child("Users")
                .child(user.uid)
                .setValue(object, withCompletionBlock: {(error, reference) in
                guard error == nil else {
                    // Bad, Error.
                    Auth.auth().currentUser?.delete(completion: { (error) in
                     completion(error)
                    })
                    return
                }
                // Good.
                if let photo = self.photo {
                    let photoData = UIImageJPEGRepresentation(photo, 0.7)
                    // Storage.storage().reference().child("Users").child(user.uid).putData(photoData!)
                    Storage.storage().reference().child("Users").child(user.uid).putData(photoData!, metadata: nil, completion: { (metaData, error) in
                        guard error == nil, let url = metaData?.downloadURL()?.absoluteString else{ return }
                        // No error.
                        Database.database().reference().child("Users").child(user.uid).updateChildValues(["url": url])
                    })
                }
                completion(nil)
            })
        })
    }
    func makeAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okay)
        return alert
    }
}
