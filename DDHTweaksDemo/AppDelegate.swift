//
//  AppDelegate.swift
//  DDHTweaksDemo
//
//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow? = ShakeableWindow(frame: UIScreen.mainScreen().bounds)

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool { return true }
}

