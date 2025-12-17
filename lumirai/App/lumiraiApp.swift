//
//  lumiraiApp.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import SwiftUI

@main
struct lumiraiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashView()
//            ExpressionView()
//            PreviewScreen()
//            CalmSessionView(currentEmotion: .anxiety, currentMode: .breath)
            
        }
    }
}
