//
//  Subscription.swift
//  lumirai
//
//  Created by dana nur fiqi on 17/12/25.
//

import Foundation
import SwiftUI

struct Subscription: View {
    @State private var goToExpression = false
    @StateObject private var viewModel = SubscriptionViewModel()
    @EnvironmentObject private var router: Router
    @State private var scale: CGFloat = 1.0
    @State private var coreOpacity: Double = 0.85
    @State private var drift: CGSize = .zero
    @State private var animate: Bool = false
    @State private var selectedPlan: String = ""
    
        
        
    
    private func jitter(_ base: Double, percent: Double = 0.08) -> Double {
        let delta = base * percent
        return base + Double.random(in: -delta...delta)
    }
    
    private func startBreathing() {
        inhale()
    }

    private func inhale() {
        let duration = jitter(AppInfo.shared.getDurationInHale)
        let targetScale = jitter(0.96, percent: 0.06)
        let targetOpacity = jitter(0.76, percent: 0.05)
        
        withAnimation(.easeInOut(duration: duration)) {
            scale = targetScale
            coreOpacity = targetOpacity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            exhale()
        }
    }

    private func exhale() {
        let duration = jitter(AppInfo.shared.getDurationExHale)
        let targetScale = jitter(1.15, percent: 0.04)
        let targetOpacity = jitter(0.88, percent: 0.04)
        
        withAnimation(.easeInOut(duration: duration)) {
            scale = targetScale
            coreOpacity = targetOpacity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            inhale()
        }
    }

    var body: some View {
        BaseView( viewModel: viewModel ) { vm in
            ZStack{
                Color(.black).ignoresSafeArea()
                GeometryReader { geo in
                    HaloDriftView {
                        ZStack {
                            HaloLightLayer(opacity: 0.35 * coreOpacity, blur: 60 + 15)
                            HaloLightLayer(opacity: 0.6  * coreOpacity, blur: 60)
                            HaloLightLayer(opacity: 1.0  * coreOpacity, blur: 60 - 10)
                        }
                        .frame(
                            width: geo.size.width * 0.70,
                            height: geo.size.width * 0.70
                        )
                        .scaleEffect(scale)
                        .offset(drift)
                    }
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    
                    .onAppear {
                        startBreathing()
                    }
                    
                }
                ZStack{
                        ParticleShimmerViewNew(
                            animate: $animate,
                            scale: $scale,
                            countParticles: 35
                        )
//                        .offset(driftParticle)
                }
                
                    VStack(alignment: .center) {
                        Text(vm.textTitle)
                            .font(AppFonts.playFairDisplayReg(size: 24))
                            .foregroundColor(.white)
                        Spacer()
                        
                        Text(vm.textContinue)
                            .font(AppFonts.playFairDisplayReg(size: 28))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        
                        
                        
                        VStack(spacing: 16) {
                            
                            CustomRadioButton(
                                title: "Yearly — €99 first year\nThen €129/year\n7-day free trial",
                                isSelected: selectedPlan == "Yearly"
                            ) {
                                selectedPlan = "Yearly"
                            }

                            CustomRadioButton(
                                title: "Monthly — €14.99/month\n7-day free trial",
                                isSelected: selectedPlan == "Monthly"
                            ) {
                                selectedPlan = "Monthly"
                            }

                            // CTA Button (already refined)
                            GlassButtonView(
                                title: "Start Free Trial",
                                textColor: .black,
                                backgroundStyle: .solid(.white)
                            ){
                                router.push(.login)
                            }
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 400)

                        // 🌫 Glass background
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black.opacity(0.12))
                                    .blur(radius: 12)

                                BlurView(style: .systemUltraThinMaterialDark)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        )

                        // Subtle border glass
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )

                        // Depth shadow
                        .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
                        .shadow(color: .white.opacity(0.06), radius: 2, x: 0, y: 0)
                        Spacer()
                        
                        Text(vm.textDescription)
                            .font(AppFonts.playFairDisplayReg(size: 15))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                            .padding(.top, 32)
                        
                        Text(vm.textCancel)
                            .font(AppFonts.playFairDisplayReg(size: 13))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 0)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                    
                
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    
}

struct BottomTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - 10)) // puncak segitiga
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        path.closeSubpath()
        return path
    }
}


#Preview {
    Subscription()
}


struct CustomRadioButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    @State private var pulse = false

    var body: some View {
        Button(action: {
            action()
            triggerPulse()
        }) {
            HStack(spacing: 12) {
                // Radio circle
                Circle()
                    .stroke(isSelected ? Color.blue.opacity(0.6) : Color.gray , lineWidth: 1)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : .clear)
                            .padding(4)
                    )
                    .frame(width: 22, height: 22)

                Text(title)
                    .font(AppFonts.playFairDisplayReg(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.blue.opacity(isSelected ? 0.35 : 0.08), lineWidth: 1)
        )

        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.blue.opacity(pulse ? 0.3 : 0), lineWidth: 2)
                .blur(radius: 14)
                .scaleEffect(pulse ? 1.06 : 1.0)
                .opacity(pulse ? 1 : 0)
        )
        .animation(.easeOut(duration: 0.22), value: pulse)
    }

    private func triggerPulse() {
        pulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            pulse = false
        }
    }
}
