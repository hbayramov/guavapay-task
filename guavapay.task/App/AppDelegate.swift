//
//  AppDelegate.swift
//  guavapay.task
//
//  Created by Huseyn Bayramov on 06.03.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UITabController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
