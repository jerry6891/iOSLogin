//
//  AppDelegate.swift
//  LiveMedia
//
//  Created by [T.T.S.D.] on 2018-04-09.
//  Copyright © 2018 GWEB. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // try? Auth.auth().signOut()
        return true
    }
}
