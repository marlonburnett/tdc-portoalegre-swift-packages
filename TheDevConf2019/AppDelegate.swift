//
//  AppDelegate.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 23/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    static var instance: AppDelegate { UIApplication.shared.delegate as! AppDelegate }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

