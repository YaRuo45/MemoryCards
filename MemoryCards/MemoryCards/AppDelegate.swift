//
//  AppDelegate.swift
//  MemoryCards
//
//  Created by Jessica Sun on 09/06/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var orientationLock: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}
