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
                    Text("LUMIRAi")
                        .font(AppFonts.playFairDisplayReg(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Spacer()
                    Text(vm.resultAction.echo)
                        .font(AppFonts.nunito(size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                }
            }
            .background(Color(hex:"#0A0F16"))
            .navigationBarBackButtonHidden()
            .onAppear {
                vm.onFinished = {
                    router.pop()
                }
            }
        }
    }
    
    
}

#Preview {
    CalmView(resultAction: GeminiActionModel(
        emotion: "anxiety",
        echo: "I realize things feel overwhelming right now, but we can take this one step at a time to find your center again.",
        action: "journal",
        durationSec: 300,
        button: "Start Breathing"
    ))
}
