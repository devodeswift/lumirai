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
                            width: geo.size.width * 0.35,
                            height: geo.size.width * 0.35
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
                        
                        
                        
                        
                        VStack{
                            CustomRadioButton(title: "Yearly — €99 first year\nThen €129/year\n7-day free trial", isSelected: selectedPlan == "Yearly") {
                                selectedPlan = "Yearly"
                            }
                            
                            CustomRadioButton(title: "Monthly — €14.99/month\n7-day free trial", isSelected: selectedPlan == "Monthly") {
                                selectedPlan = "Monthly"
                            }
                            
                            
                            Button(action: {
                                router.push(.expression)
                            }) {
                                Text(vm.textTrial)
                                    .font(AppFonts.playFairDisplayReg(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "#2A2A2A"), lineWidth: 1)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                            )
                            
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 400)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#2A2A2A"), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#1A1A1A"))
                                .opacity(0.1)
                        )
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
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment:.top, spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                        .frame(width: 20, height: 20)
                        
                    
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 10)
                Text(title)
                    .font(AppFonts.playFairDisplayReg(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
