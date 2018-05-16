//
//  SignupController.swift
//  LiveMedia
//
//  Created by Rex Karnufex on 2018-04-23.
//  Copyright © 2018 GWEB. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class SignupController: UIViewController {
    let model = SignupModel()   // New instance creation.
    //MARK: IB Outlets
    @IBOutlet fileprivate var photoButton: UIButton!
    @IBOutlet fileprivate var fields: [UITextField]!
    
    @IBOutlet fileprivate var indicator: UIActivityIndicatorView!
    
    //MARK: IB Actions
    @IBAction fileprivate func signupTapped(_ sender: UIButton) {
        /* let username = fields[0].text
        let email = fields[1].text
        let password = fields[2].text
        let confirmpassword = fields[3].text */
        
        /* print("1: \(username)")
        print("2: \(email)")
        print("3: \(password)")
        print("4: \(confirmpassword)") */
        
        /* var data = [String: String]()
        data["username"] = fields[0].text
        data["email"] = fields[1].text
        data["password"] = fields[2].text
        data["confirmpassword"] = fields[3].text
        if model.validate(data: data){
            Auth.auth().createUser(withEmail: data["email"]!, password: data["password"]!) { (user, error) in
                if error == nil {
                    var object = [String: String]()
                    object["email"] = data["email"]!
                    object["username"] = data["username"]!
                    
                    Database.database().reference().child("Users").childByAutoId().setValue(object, withCompletionBlock: { (error, reference) in
                        if error == nil {
                            let data = UIImageJPEGRepresentation(self.model.photo!, 0.7)            // Between 0 to 1
                            Storage.storage().reference().child("Users").child("photo1").putData(data!)
                        } else {
                            
                        }
                    })
                    
                } else {
                    // Error.
                }
            }
        }else{
            let alert = UIAlertController(title: "What?...", message: "invalid.input", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        } */
        
       // data.map{((key: String, value: String?) -> [String: String] in )}
        indicator.startAnimating()
        sender.isEnabled = false
        
        var data = [String: String]()
        // var data = [String: String] = [:]
        // data["username"] = fields[0].text
        if let username = fields[0].text {
            data["username"] = username
        }
        if let email = fields[1].text {
            data["email"] = email
        }
        if let password = fields[2].text {
            data["password"] = password
        }
        if let confirmpassword = fields[2].text {
            data["confirmpassword"] = confirmpassword
        }
        if model.validate(data: data) {
            model.authenticate(data: data) { (error) in
                self.indicator.stopAnimating()
                sender.isEnabled = true
                guard error == nil else {
                    // BAD.
                    let alert = self.model.makeAlert(message: "Failed To Sign Up!")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                // Good.
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            indicator.stopAnimating()
            sender.isEnabled = true
            let alert = self.model.makeAlert(message: "Invalid Input")
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction fileprivate func photoTapped(_ sender: UIButton) {
        media(sourceType: .photoLibrary)
    }
    @IBAction fileprivate func dismissTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
}

// Image Upload Function. 
extension SignupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoButton.setBackgroundImage(image, for: .normal)
            model.photo = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func media(sourceType: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        parent?.present(picker, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience public init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience public init(hexadecimal: Int) {
        self.init(red:(hexadecimal >> 16) & 0xff, green:(hexadecimal >> 8) & 0xff, blue:hexadecimal & 0xff)
    }
}

extension SignupController{
    fileprivate func setView(){
        let gradient = CAGradientLayer()
        let color1 = UIColor(hexadecimal: 0xFFB4B4)
        let color2 = UIColor(hexadecimal: 0x867AC7)
        let colors: [CGColor] = [color1.cgColor, color2.cgColor]
        // let start = CGPoint(x: 0, y: 0)
        // let end = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
        // gradient.startPoint = start
        // gradient.endPoint = end
        
        // let start = CGPoint(x: UIScreen.main.bounds.width/2, y: 0)
        // let end = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height)
        gradient.colors = colors
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
