//
//  AppDelegate.swift
//  VolleyStats
//
//  Created by Pieter Bikkel on 23/10/2023.
//

import UIKit
import Foundation

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all 

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
