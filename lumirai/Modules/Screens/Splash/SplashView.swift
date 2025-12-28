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
            BaseView(viewModel: viewModel) { vm in
                ZStack {
                    AuroraBackgroundView(
                        baseColor: Color("#0A0F16"), topLeftColor: Color("#00C4B4"), topRightColor: Color("#F5E9C5"), bottomColor: Color("#5648A8")
                    )
                    VStack {
                        Spacer()
                        Text(vm.textLogo)
                            .font(AppFonts.playFairDisplayReg(size: 28))
                            .foregroundColor(Color("#EAF6F5"))
                        Spacer()
                        Text(vm.textVersion)
                            .font(AppFonts.playFairDisplayReg(size: 14))
                            .foregroundColor(Color("#EAF6F5"))
                    }
                    .padding()
                }
                .onChange(of: vm.shouldNavigate){
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
}

#Preview {
    SplashView()
}
