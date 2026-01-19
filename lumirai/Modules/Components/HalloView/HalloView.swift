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

struct HaloView: View {

    private let backgroundColor = Color(hex: "#0D1117")
    private let haloCoreColor = Color(hex: "#E6F0FF")
    let startAnimation: Bool

    var body: some View {
        ZStack {
            ForEach(1...8, id: \.self) { index in
                Circle()
                    .fill(haloCoreColor.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .scaleEffect(startAnimation ? 0.1 : 1.0)
                    .opacity(startAnimation ? 0.25 : 1)
                    .offset(x: startAnimation ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(index) * 45))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0))
            }
        }
    }
}
    

#Preview {
    ZStack{
        Color.black
            .ignoresSafeArea()
        HaloView(startAnimation: true)
    }
    
}
