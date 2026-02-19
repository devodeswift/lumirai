//
//  CalmView.swift
//  lumirai
//
//  Created by dana nur fiqi on 11/12/25.
//

import Foundation
import SwiftUI
import SceneKit
import Combine

struct CalmView: View{
    @StateObject private var calmviewModel: CalmViewModel
    @EnvironmentObject private var router: Router
    @State private var animate: Bool = false
    @State private var coreOpacity: Double = 0.85
    @StateObject private var breath = HaloBreathingController()
    @State private var scale: CGFloat = 1.0
    @State private var echoSnapshot: String = ""
    @State private var didFreezeEcho = false
    @State private var displayedText = ""
    @State private var opacity = 1.0
    
    init(resultAction: GeminiActionModel) {
        _calmviewModel = StateObject(wrappedValue: CalmViewModel(resultAction: resultAction))
    }
    
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
        BaseView(viewModel: calmviewModel) { vm in
            ZStack {
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
                }
                VStack(alignment: .center) {
                    ZStack {
                        HStack(spacing: 16) {
                            GlassButtonImageView(image: Image(systemName: "chevron.left")) {
                                router.pop()
                                vm.stopTimer()
                            }
                            .frame(width: 60)

                            Spacer()
                        }

                        Text("LUMIRAi")
                            .font(AppFonts.playFairDisplayReg(size: 24))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    Text(vm.currentSentence)
                        .font(AppFonts.nunito(size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        .id(vm.currentSentence) // 🔥 force new view
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.5), value: vm.currentSentence)
                }
            }
            .background(Color(hex:"#0A0F16"))
            .navigationBarBackButtonHidden()
            .onAppear {
                vm.onFinished = {
                    router.pop()
                    vm.stopTimer()
                }
            }
            .gesture(
                DragGesture().onEnded { value in
                    if value.translation.width > 100 {
                        router.pop()
                        vm.stopTimer()
                    }
                }
            )
        }
    }
    
    
}


#Preview {
    CalmView(resultAction: GeminiActionModel(
        emotion: "anxiety",
        echo: "I realize.|test kalimat.|kalimatnya tersebut",
        action: "journal",
        durationSec: 300,
        button: "Start Breathing"
    ))
}
