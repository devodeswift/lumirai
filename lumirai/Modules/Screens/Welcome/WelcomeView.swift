//
//  WelcomeView.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import SwiftUI
import Combine

struct WelcomeView: View {
    @State private var animate = false
    @State private var visibleCount: Int = 0
    @State private var showLetter = false
    @State private var showSubtitle: Bool = false
    @State private var showParticles = false
    @State private var showButton = false
    @StateObject private var viewModel = WelcomeViewModel()
    @EnvironmentObject private var router: Router
    
    
    var body: some View {
        BaseView(viewModel: viewModel) { vm in
            ZStack {
                Color("#0A0F16").ignoresSafeArea()
                bigHaloBreathing()
                if showParticles {
                    ParticleShimmerView()
                        .allowsHitTesting(false)
                }
                VStack{
                    if showLetter {
                        sequentialFadeText(letters: vm.letters)
                    }
                    Spacer()
                        .frame(height: 20)
                    if showSubtitle {
                        VStack(spacing: 4) {
                            Text(vm.txtTittleTop)
                                .font(AppFonts.playFairDisplayReg(size: 18))
                                .foregroundColor(Color("#EAF6F5"))
                                .opacity(showSubtitle ? 1 : 0)
                            Text(vm.txtTittleBot)
                                .font(AppFonts.playFairDisplayReg(size: 18))
                                .foregroundColor(Color("#EAF6F5"))
                                .opacity(showSubtitle ? 1 : 0)
                        }
                        .multilineTextAlignment(.center)
                    }
                    Spacer()
                        .frame(height: 98)
                    if showButton {
                        GlassButtonView(title: vm.textButton) {
                            if vm.isLoggingIn {
                                router.push(.subscription)
                            } else {
                                router.push(.login)
                            }
                            
                            
                        }
                        .frame(width: 180)
                        .scaleEffect(animate ? 1.02 : 0.98)
                        .opacity(animate ? 1.02 : 0.98)
                        .animation(
                            Animation.easeInOut(duration: 6.0)
                                .repeatForever(autoreverses: true),
                            value: showButton
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .navigationDestination(isPresented: $goToLogin) {
//                LoginView()
//            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let url = Bundle.main.url(forResource: "ambient", withExtension: "mp3") {
                        vm.audio.playWithFadeIn(url: url, duration: 0.1)
                    }
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showLetter = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.38) {
                        withAnimation(.easeInOut(duration: 1.22)) {
                            showSubtitle = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 1.3)) {
                            showParticles = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 1.4)) {
                            showButton = true
                            vm.audio.stopWithFadeOut(duration: 2)
                        }
                    }
                }
            }
        }
    }
    
    func bigHaloBreathing() -> some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("#00C4B4"),
                        Color("#5648A8"),
                        Color("#F5E9C5")
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 240
                )
            )
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .blur(radius: 70)
            .scaleEffect(animate ? 1.15 : 0.95)
            .opacity(animate ? 0.9 : 0.4)
            .animation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
    
    func sequentialFadeText(letters: [String]) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<letters.count, id: \.self) { index in
                Text(letters[index])
                    .font(AppFonts.playFairDisplayReg(size: 28))
                    .foregroundColor(Color("#EAF6F5"))
                    .opacity(visibleCount > index ? 1 : 0)
                    .animation(.easeOut(duration: 0.30).delay(Double(index) * 0.18), value: visibleCount)
            }
        }
        .onAppear {
            visibleCount = letters.count
        }
        
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Router())
}
