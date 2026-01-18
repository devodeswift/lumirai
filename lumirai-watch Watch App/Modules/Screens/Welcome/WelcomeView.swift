//
//  WelcomeView.swift
//  lumirai-watch Watch App
//
//  Created by dana nur fiqi on 05/01/26.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var animate = false
    
    
    
    func bigHaloBreathing() -> some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#00C4B4"),
                        Color(hex: "#5648A8"),
                        Color(hex: "#F5E9C5")
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 200
                )
            )
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .blur(radius: 70)
            .scaleEffect(animate ? 1.15 : 0.95)
            .opacity(animate ? 0.9 : 0.4)
            .animation(
                Animation.easeInOut(duration: 6.5)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
    
    var body: some View {
        BaseView(viewModel: viewModel) { vm in
            
            ZStack{
                Color(hex: "#0A0F16")
                    .ignoresSafeArea()
                bigHaloBreathing()
                Text("LUMIRAi")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(AppFonts.playFairDisplayReg(size: 28))
                    .foregroundColor(Color(hex: "#EAF6F5"))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear{
                vm.refreshVitals()
            }
        }
    }
    
    
}

#Preview {
    WelcomeView()
}
