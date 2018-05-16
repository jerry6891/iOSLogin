//
//  MeController.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-05-07.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class MeController: UIViewController{
    fileprivate var profile: Profile?
    
    @IBOutlet private var overlay: UIView!
    @IBOutlet private var indicator: UIActivityIndicatorView!
    @IBOutlet private var ageField: UITextField!
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var aboutField: UITextView!
    
    @IBAction func savedTapped(_ sender: UIBarButtonItem) {
        self.showOverlay()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
            self?.hideOverlay()
        }
        guard
            let name = nameField.text,
            let age = ageField.text,
            let about = aboutField.text,
            let UID = Auth.auth().currentUser?.uid else{
                return
        }
        var object = [String: String]()
        object["username"] = name
        object["age"] = age
        object["about"] = about
        Database.database().reference().child("Users").child(UID).updateChildValues(object)
        if let image = self.ProfileImageView.image{
            let data = UIImageJPEGRepresentation(image, 0.6)!
            Storage.storage()
                .reference()
                .child("Users")
                .child(UID)
                .putData(data, metadata: nil) { (metadata, error) in
                    guard let absolute = metadata?.downloadURL()?.absoluteString else{ return }
                    Database.database().reference().child("Users").child(UID).updateChildValues(["url":absolute])
            }
        }
    }
    @IBOutlet private var ProfileImageView: UIImageView!
    @objc func imageViewTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImageView()
        setFields()
        loadData()
        loadPhoto()
        setOverlay()
        showOverlay()
    }
    
    private func showOverlay(){
        self.indicator.startAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.overlay.alpha = 0.8
        }
    }
    private func hideOverlay(){
        indicator.stopAnimating()
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.overlay.alpha = 0
        }
    }
}

fileprivate extension MeController{
    func loadData(){
        if let UID = Auth.auth().currentUser?.uid{
            Database.database().reference()
                .child("Users")
                .child(UID)
                .observeSingleEvent(of: .value) { [weak self] snapshot in
                let profile = Profile(snapshot: snapshot)
                    self?.profile = profile
                    // print(profile)
                    self?.ageField.text = profile?.age ?? ""
                    self?.aboutField.text = profile?.about ?? ""
                    self?.nameField.text = profile?.username ?? ""
            }
        }
    }
    func loadPhoto(){
        guard let UID = Auth.auth().currentUser?.uid else{ return }
        Storage.storage().reference()
            .child("Users")
            .child(UID).getData(maxSize: 2024*1000) { [weak self] (data, error) in
                self?.hideOverlay()
                guard let data = data else { return }
                self?.ProfileImageView.image = UIImage(data: data)
        }
    }
}

fileprivate extension MeController{
    func setupProfileImageView(){
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(imageViewTapped))
        ProfileImageView.addGestureRecognizer(recognizer)
    }
    func setFields(){
        self.nameField.text = ""
        self.ageField.text = ""
        self.aboutField.text = ""
    }
    
    func setOverlay(){
        self.view.addSubview(overlay)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        overlay.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        overlay.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        overlay.alpha = 0
        // overlay.isHidden = true
    }
}
extension MeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.ProfileImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
