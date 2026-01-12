//
//  RootView.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/01/26.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject private var router = Router()

    var body: some View {
        NavigationStack(path: $router.path) {
            SplashView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .welcome:
                        WelcomeView()
                    case .login:
                        LoginView()
                    case .subscription:
                        Subscription()
                    }
                }
        }
        .environmentObject(router)
    }
}
