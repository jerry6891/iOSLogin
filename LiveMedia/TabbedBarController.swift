//
//  ViewController.swift
//  LiveMedia
//
//  Created by [T.T.S.D.] on 2018-04-09.
//  Copyright © 2018 GWEB. All rights reserved.
//

import UIKit

class TabbedBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(presentLogin), with: self, afterDelay: 0)
    }
    @objc func presentLogin(){
        let storyboard = UIStoryboard(name: "LoginController", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as!
            LoginController
        present(controller, animated: true, completion: nil)
    }
}
