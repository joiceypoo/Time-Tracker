//
//  AppDelegate.swift
//  Time-Tracker
//
//  Created by Joiceypoo 🎉 on 12/11/18.
//  Copyright © 2018 Team Sweet Cheeks. All rights reserved.
//

import UIKit


class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .customBlack
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().titleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        return true
    }
}
