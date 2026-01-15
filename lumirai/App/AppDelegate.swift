//
//  AppDelegate.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import UIKit
import GoogleSignIn
import netfox

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .forEach { windowScene in
                    windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
        
        #if DEBUG
            NFX.sharedInstance().start()
        #endif
        
        return true
    }
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            GIDSignIn.sharedInstance.handle(url)
        }
}
