//
//  AppDelegate.swift
//  CommonCryptoExample
//
//  Created by Toomas Vahter on 29/04/2018.
//  Copyright © 2018 Augmented Code. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let someData = "Random string".data(using: .utf8) {
            let hash = someData.hash(for: .sha256)
            print("hash=\(hash.base64EncodedString()).")
        }
        
        return true
    }
}
