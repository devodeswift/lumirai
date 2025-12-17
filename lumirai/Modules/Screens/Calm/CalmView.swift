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
    @State private var rotateSmoke = false
    @State private var blink = false
    @State private var isVisible: Bool = false
    @State private var breatheState: Bool = false
    @State private var progress: CGFloat = 0.0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var timeElapsed: Double = 0
    let totalDuration: Double = 30
    
    var body: some View{
        ZStack{
            background()
                .ignoresSafeArea()
            VStack{
                Text("LUMIRAi")
                    .font(AppFonts.playFairDisplayReg(size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 10)
//                Spacer()
                halo()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                isVisible = true
            }
            startBreathingCycle()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
    }
    
    func background() -> some View {
        ZStack {
            Color(hex: "0A0F16") // Base
            RadialGradient(
                colors: [Color(hex: "1E546F").opacity(0.4), .clear],
                center: .bottom,
                startRadius: 0,
                endRadius: 500
            )
            .opacity(breatheState ? 1 : 0) // Soft Fade Entry (1.5s)
            .animation(.easeInOut(duration: 1.5), value: breatheState)
            RadialGradient(
                colors: [Color(hex: "1E546F").opacity(0.4), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .opacity(breatheState ? 1 : 0) // Soft Fade Entry (1.5s)
                .animation(.easeInOut(duration: 1.5), value: breatheState)
        }
    }
    
    func halo() -> some View {
        ZStack{
            HalloView( config:
                        HaloViewModel(colors: [
                            // amber
                            Color(hex: "E6FFFB").opacity(0.95),
                            Color(hex: "B2F5EA").opacity(0.85),
                            Color(hex: "81E6D9").opacity(0.75),
                            Color(hex: "4FD1C5").opacity(0.68),
                            Color(hex: "FCD34D").opacity(0.60),
                            Color(hex: "F59E0B").opacity(0.50)
                            
                            
                            //                    Color(hex: "FFF6D6").opacity(0.95), // ivory gold core
                            //                    Color(hex: "F5E9C5").opacity(0.88), // soft champagne
                            //                    Color(hex: "E6C97A").opacity(0.78), // classic gold
                            //                    Color(hex: "C9A24D").opacity(0.68), // warm antique gold
                            //                    Color(hex: "8C6A2B").opacity(0.55), // deep bronze
                            //                    Color(hex: "2B2416").opacity(0.90)  // dark gold shadow
                            
                            //                    Color(hex: "F2F0E6").opacity(0.90),
                            //                    Color(hex: "C4D7ED").opacity(0.70),
                            //                    Color(hex: "7A92A3").opacity(0.55),
                            //                    Color(hex: "4B6375").opacity(0.40),
                            //                    Color(hex: "1F2D3D").opacity(0.20),
                            //                    Color(hex: "0A0F16").opacity(0.00)
                            
                            
                            
                        ])
            )
            .frame(width: breatheState || progress == 1.0 ? 300 : 150, height: breatheState || progress == 1.0 ? 300 : 150)
            
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundColor(.white.opacity(0.5))
                .rotationEffect(.degrees(-90))
                .frame(width: 320, height: 320)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "7FF5F5").opacity(0.85), // light cyan highlight
                            Color(hex: "4FD1C5").opacity(0.95), // aqua cyan
                            Color(hex: "2EC4B6").opacity(1.0),  // deep cyan
                            Color(hex: "4FD1C5").opacity(0.95),
                            Color(hex: "7FF5F5").opacity(0.85)
                        ]),
                        center: .center
                    ),
                        style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 320, height: 320)
        }
    }
    
    
    func startBreathingCycle() {
        // Breath Cadence Logic (e.g., 4-6)
        // Ini loop animasi sederhana
        let inhaleDuration: Double = 4.0
        let exhaleDuration: Double = 6.0
        
        withAnimation(.easeInOut(duration: inhaleDuration)) {
            breatheState = true // Expand (Inhale)
//            instructionText = "Slow Inhale..."
        }
        
        // Schedule Exhale
        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            withAnimation(.easeInOut(duration: exhaleDuration)) {
                breatheState = false // Shrink (Exhale)
//                instructionText = "Exhale..."
            }
            
            // Loop (Recursive for demo)
            DispatchQueue.main.asyncAfter(deadline: .now() + exhaleDuration) {
                if self.progress < 1.0 { // Stop if session ends
                    self.startBreathingCycle()
                }else {
                    withAnimation(.easeInOut(duration: inhaleDuration)) {
                        breatheState = true // Expand (Inhale)
            //            instructionText = "Slow Inhale..."
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
}

#Preview {
    CalmView()
}
