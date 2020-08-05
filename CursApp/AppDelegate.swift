//
//  AppDelegate.swift
//  CursApp
//
//  Created by lailiang on 2020/7/15.
//  Copyright © 2020 lailiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppState.share.setup()
        return true
    }
    
}

