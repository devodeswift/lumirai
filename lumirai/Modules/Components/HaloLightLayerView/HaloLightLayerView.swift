//
//  HaloLightLayerView.swift
//  lumirai
//
//  Created by dana nur fiqi on 10/03/26.
//

import Foundation
import SwiftUI


struct HaloLightLayerView: View {
    let opacity: Double
    let blur: CGFloat
    var colorCore: Color = Color(hex: "#7DB5E8")
    var colorOuter: Color = Color(hex: "#5A9FDB")

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: colorOuter.opacity(opacity), location: 0.0),
                        .init(color: colorOuter.opacity(opacity * 0.7), location: 0.5),
                        .init(color: colorCore.opacity(0.05), location: 1.0)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 300
                )
            )
            .blur(radius: blur)
            .blendMode(.plusLighter)
    }
}

struct PreviewHaloLightLayer: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            HaloDriftView {
                ZStack {
                    HaloLightLayerView(opacity: 0.35, blur: 75)
                    HaloLightLayerView(opacity: 0.6, blur: 60)
                    HaloLightLayerView(opacity: 0.88, blur: 50)
                }
                .frame(
                    width: geo.size.width * 0.70,
                    height: geo.size.width * 0.70
                )
                .scaleEffect(animate ? 1.5 : 1.0)
            }
            .position(
                x: geo.size.width / 2,
                y: geo.size.height / 2
            )
            
            .animation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
        }
        .ignoresSafeArea()
        .background(Color.black)
    }
}

#Preview {
    PreviewHaloLightLayer()
}

