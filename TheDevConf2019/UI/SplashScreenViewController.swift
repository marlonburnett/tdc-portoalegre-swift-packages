//
//  SplashScreenViewController.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    lazy var navController: UINavigationController = {
        let navController = UINavigationController()
        navController.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            navController.navigationBar.barTintColor = UIColor.systemBackground
            navController.navigationBar.tintColor = UIColor.label
            navController.navigationBar.backgroundColor = UIColor.systemBackground
            navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        } else {
            navController.navigationBar.barTintColor = UIColor.white
            navController.navigationBar.tintColor = UIColor.black
            navController.navigationBar.backgroundColor = UIColor.white
            navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        
        return navController
    }()
    
    lazy var rootViewController: UIViewController = {
        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        self.navController.setViewControllers([initialViewController], animated: false)
        
        return navController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = self.rootViewController
            
            AppDelegate.instance.window = window

            window.makeKeyAndVisible()
        }
    }
}
