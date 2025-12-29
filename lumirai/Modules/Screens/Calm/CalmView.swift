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
    @State private var animate = false
    @State private var breatheState = false
    @State private var isStart: Bool = false
    
    var auroraColors: [Color] = [
            Color(hex: "F5F3ED"), // Ivory
            Color(hex: "C9D6E8")  // Pale Blue
        ]
    @State private var progress: CGFloat = 0.0
        
        let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
        @State private var timeElapsed: Double = 0
        let totalDuration: Double = 30
    
    @StateObject private var calmviewModel = CalmViewModel()
    
    //MARK: - Func View
    func background() -> some View {
        GeometryReader { geo in
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.18),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 50,
                    endRadius: 380
                )
                .blendMode(.softLight)

                LinearGradient(
                    colors: auroraColors,
                    startPoint: animate ? .topLeading : .bottomTrailing,
                    endPoint: animate ? .bottomTrailing : .topLeading
                )
                .opacity(0.28)
                .blur(radius: 80)
                .blendMode(.screen)
                .animation(
                    .easeInOut(duration: 6).repeatForever(autoreverses: true),
                    value: animate
                )
                
                StaticNebulusHalo(size: geo.size.height)
                    .frame(width: breatheState && progress < 1 ? geo.size.height : 100, height: breatheState && progress < 1 ? geo.size.height : 100)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
            }
        }
        

    }
    
    func TimerLine(
        progress: Double,
        color: Color
    ) -> some View {

        GeometryReader { geo in
            Capsule()
                .fill(color)
                .frame(
                    width: geo.size.width * progress,
                    height: 2
                )
                .opacity(0.45)
                .animation(.easeInOut, value: progress)
        }
    }
    
    
    //MARK: -Func logic
    func startBreathingCycle() {
        let inhaleDuration: Double = 4.0
        let exhaleDuration: Double = 6.0
        
        withAnimation(.easeInOut(duration: inhaleDuration)) {
            breatheState = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            withAnimation(.easeInOut(duration: exhaleDuration)) {
                breatheState = false
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + exhaleDuration) {
                if self.progress < 1.0 {
                    self.startBreathingCycle()
                }else {
                    withAnimation(.easeInOut(duration: inhaleDuration)) {
                        breatheState = true
                    }
                }
            }
        }
    }
    
    func updateTimer() {
        if timeElapsed < totalDuration {
            timeElapsed += 0.05
            withAnimation {
                progress = CGFloat(timeElapsed / totalDuration)
            }
            AppLogger.shared.log(" cek progress : \(breatheState) : \(progress)")
        }
    }
    
    var body: some View {
        BaseView(viewModel: CalmViewModel()) { vm in
            ZStack {
                Color(hex: "0A0F16")
                    .ignoresSafeArea()
                background()
                    .ignoresSafeArea()
                VStack{
                    Text("LUMIRAi")
                        .font(AppFonts.playFairDisplayReg(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Spacer()
                    if isStart {
                        Text("Intruction")
                            .font(AppFonts.nunito(size: 24))
                            .foregroundColor(.white)
                        
                        .frame(width: .infinity)
                        .padding(.horizontal, 10)
                        TimerLine(
                            progress: progress,
                            color: Color(hex: "C9D6E8")
                        )
                        .frame(height: 2)
                    } else{
                        GlassButtonView(title: "Start"){
                            isStart.toggle()
                        }
                    }
                }
                .animation(nil, value: breatheState)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                startBreathingCycle()
                animate = true
            }
            .onReceive(timer) { _ in
                updateTimer()
            }
        }
    }
    
}

#Preview {
    CalmView()
}
