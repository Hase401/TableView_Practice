//
//  AppDelegate.swift
//  TableView_Practice1
//
//  Created by 長谷川孝太 on 2021/08/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.rootViewController = TabBarController.init()
        self.window?.makeKeyAndVisible()
        return true
    }

}

