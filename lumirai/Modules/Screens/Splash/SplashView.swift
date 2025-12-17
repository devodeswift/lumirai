//
//  SplashView.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                AuroraBackgroundView(
                    baseColor: Color("#0A0F16"), topLeftColor: Color("#00C4B4"), topRightColor: Color("#F5E9C5"), bottomColor: Color("#5648A8")
                )
                VStack {
                    Spacer()
                    Text("LUMIRAi")
                        .font(AppFonts.playFairDisplayReg(size: 28))
                        .foregroundColor(Color("#EAF6F5"))
                    Spacer()
                    Text("Version \(AppInfo.shared.getAppVersion)")
                        .font(AppFonts.playFairDisplayReg(size: 14))
                        .foregroundColor(Color("#EAF6F5"))
                }
                .padding()
            }.onChange(of: viewModel.shouldNavigate){
                shouldNavigate in
                if shouldNavigate {
                    navigateToHome = true
                    
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                WelcomeView()
            }
        }
    }
}

#Preview {
    SplashView()
}
