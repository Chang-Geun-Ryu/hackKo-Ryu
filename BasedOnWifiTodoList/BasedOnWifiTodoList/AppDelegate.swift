//
//  AppDelegate.swift
//  TestCollectionView
//
//  Created by CHANGGUEN YU on 26/06/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  let notiManager = UNNotificationManager()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    notiManager.register()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
    
    let navi = UINavigationController(rootViewController: MainVC())
    window?.rootViewController = navi
    
    return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    print("back")
    MainVC.isBackgound = true
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    print("Fore")
    MainVC.isBackgound = false
  }
}

