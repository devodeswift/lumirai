//
//  HalloView.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/12/25.
//
import SwiftUI

struct HalloView: View {
    
    let config: HaloViewModel
    
    @State private var rotateSmoke = false
    @State private var blink = false
    @State private var float = false
    
    var body: some View {
        GeometryReader { geo in
            let parentSize = min(geo.size.width, geo.size.height)
            let smokeSize = parentSize * 0.6
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient( colors: config.colors),
                            center: .init(x: 0.40, y: 0.37),
                            startRadius: 10,
                            endRadius: 240
                            
                        )
                    )
                    .shadow(color: Color.white.opacity(0.4), radius: 40)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.7),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 6
                            )
                            .blur(radius: 10)
                    )
                
                // MARK: - HIGHLIGHT TOP LIGHT
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0)
                            ]),
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 90
                        )
                    )
                    .blur(radius: 25)
                
                
                //smoke
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.0),
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.0),
                                Color.white.opacity(0.8),
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.0)
                            ]),
                            center: .center
                        ),
                        lineWidth: 18
                    )
                    .blur(radius: 22)                // soft smoke
                    .rotationEffect(.degrees(rotateSmoke ? 360 : 0))
                    .scaleEffect(1)
                    .frame(width: smokeSize, height: smokeSize)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 6)
                            .repeatForever(autoreverses: false)
                        ) {
                            rotateSmoke = true
                        }
                    }
            }
        }
    }
}

#Preview {
//    HalloView(
//        config: Color([
//            Color(hex: "E6F1FF").opacity(0.92),
//            Color(hex: "B6D6FF").opacity(0.82),
//            Color(hex: "7FAEFF").opacity(0.74),
//            Color(hex: "6B7CFF").opacity(0.70),
//            Color(hex: "7A63C8").opacity(0.62),
//            Color(hex: "2B2F3F").opacity(0.55),
//            Color(hex: "0A0F16").opacity(0.10)
//        ])
//    )
    HalloView(
        config: HaloViewModel(
            colors: [
                Color(hex: "E6F1FF").opacity(0.92),
                Color(hex: "B6D6FF").opacity(0.82),
                Color(hex: "7FAEFF").opacity(0.74),
                Color(hex: "6B7CFF").opacity(0.70),
                Color(hex: "7A63C8").opacity(0.62),
                Color(hex: "2B2F3F").opacity(0.55),
                Color(hex: "0A0F16").opacity(0.10)
            ]
        )
    )
}
