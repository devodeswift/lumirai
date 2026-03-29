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
    @State private var animate: Bool = false
    @State private var selectedPlan: String = ""
    @State private var animatedScale: CGFloat = 1.0
    @State private var animatedCoreOpacity: Double = 0.85
    
    
    var body: some View {
        BaseView( viewModel: viewModel ) { vm in
            ZStack{
                Color(.black).ignoresSafeArea()
                
                GeometryReader { geo in
                    ZStack {
                        HaloLightLayerView(opacity: 0.35 * animatedCoreOpacity, blur: 75)
                        HaloLightLayerView(opacity: 0.6  * animatedCoreOpacity, blur: 60)
                        HaloLightLayerView(opacity: 1.0  * animatedCoreOpacity, blur: 50)
                    }
                    .frame(
                        width: geo.size.width * 0.65,
                        height: geo.size.width * 0.65
                    )
                    .blendMode(.plusDarker)
                    .blur(radius: 10)
                    .scaleEffect(animatedScale)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    
                    .onChange(of: vm.scale) { newValue in
                        withAnimation(.easeInOut(duration: vm.duration)) {
                            animatedScale = newValue
                        }
                    }
                    
                    
                    .onChange(of: vm.coreOpacity) { newValue in
                        withAnimation(.easeInOut(duration: vm.duration)) {
                            animatedCoreOpacity = newValue
                        }
                    }
                    .onAppear {
                        vm.startBreathing()
                    }
                }
                
                ZStack{
                    ParticleView(
                        animate: $animate,
                        countParticles: 35
                    )
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
                        
                        RadioButtonView(
                            title: "Yearly — €99 first year\nThen €129/year\n7-day free trial",
                            isSelected: selectedPlan == "Yearly"
                        ) {
                            selectedPlan = "Yearly"
                        }
                        
                        RadioButtonView(
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
                        .disabled(selectedPlan.isEmpty)
                        .opacity(selectedPlan.isEmpty ? 0.4 : 1)
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



#Preview {
    Subscription()
}



