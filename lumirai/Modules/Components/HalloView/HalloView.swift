//
//  HalloView.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/12/25.
//
import SwiftUI

struct StaticNebulusHalo: View {
    var size: CGFloat = 170
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "E6F0FF").opacity(0.25),
                            Color(hex: "E6F0FF").opacity(0.08),
                            .clear
                        ]),
                        center: .init(x: 0.46, y: 0.44), // subtle asymmetry
                        startRadius: size - 130,
                        endRadius: size
                    )
                )
                .blur(radius: 42)
                .blendMode(.screen)

            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#E6F0FF").opacity(0.95),
                            Color(hex: "E6F0FF").opacity(0.55),
                            .clear
                        ]),
                        center: .init(x: 0.52, y: 0.48),
                        startRadius: 0,
                        endRadius: size - 75
                    )
                )
                .blur(radius: 22)
                .blendMode(.screen)
        }
    }
}

#Preview {
    ZStack{
        Color.black
            .ignoresSafeArea()
        StaticNebulusHalo()
    }
    
}
