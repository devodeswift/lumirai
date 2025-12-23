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
//    HalloView(
//        config: HaloViewModel(
//            colors: [
//                Color(hex: "E6F1FF").opacity(0.92),
//                Color(hex: "B6D6FF").opacity(0.82),
//                Color(hex: "7FAEFF").opacity(0.74),
//                Color(hex: "6B7CFF").opacity(0.70),
//                Color(hex: "7A63C8").opacity(0.62),
//                Color(hex: "2B2F3F").opacity(0.55),
//                Color(hex: "0A0F16").opacity(0.10)
//            ]
//        )
//    )
    
//    SpiralHaloFlowView(
//        size: 200,
//        lineCount: 100,
//        color: Color(hex: "5FA8FF")
//    )
    
//    EnergyHaloView(size: 300)
//        .shadow(color: .cyan.opacity(0.4), radius: 30)
    ZStack{
        Color.black.ignoresSafeArea()
//        NebulusHaloView()
        StaticNebulusHalo()
            .frame(width: 800, height: 800)
    }
    
    
}


//struct SpiralHaloView: View {
//    var size: CGFloat = 260
//    var lineCount: Int = 90
//    var color: Color = Color(hex: "5FA8FF")
//
//    @State private var rotation: Double = 0
//
//    var body: some View {
//        Canvas { context, canvasSize in
//            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
//
//            for i in 0..<lineCount {
//                let progress = Double(i) / Double(lineCount)
//                let angle = progress * 2 * .pi
//                let radius = size / 2
//
//                var path = Path()
//                path.move(to: center)
//
//                path.addLine(
//                    to: CGPoint(
//                        x: center.x + cos(angle) * radius,
//                        y: center.y + sin(angle) * radius
//                    )
//                )
//
//                context.stroke(
//                    path,
//                    with: .color(
//                        color.opacity(0.15 + progress * 0.6)
//                    ),
//                    lineWidth: 1
//                )
//            }
//        }
//        .frame(width: size, height: size)
//        .rotationEffect(.degrees(rotation))
//        .animation(
//            .linear(duration: 20)
//                .repeatForever(autoreverses: false),
//            value: rotation
//        )
//        .onAppear {
//            rotation = 360
//        }
//    }
//}

struct SpiralHaloFlowView: View {
    var size: CGFloat = 280
    var lineCount: Int = 120
    var color: Color = Color(hex: "6FA8FF")

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, canvasSize in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let phase = CGFloat(time.truncatingRemainder(dividingBy: 20)) / 20 * .pi * 2

                let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
                let radius = size / 2

                for i in 0..<lineCount {
                    let progress = CGFloat(i) / CGFloat(lineCount)
                    let angle = progress * .pi * 2 + phase

                    var path = Path()
                    path.move(to: center)
                    path.addLine(
                        to: CGPoint(
                            x: center.x + cos(angle) * radius,
                            y: center.y + sin(angle) * radius
                        )
                    )

                    context.stroke(
                        path,
                        with: .color(
                            color.opacity(0.1 + progress * 0.7)
                        ),
                        lineWidth: 1
                    )
                }
            }
        }
        .frame(width: size, height: size)
    }
}


struct EnergyHaloView: View {
    var size: CGFloat = 260

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .stroke(
                    RadialGradient(
                        colors: [
                            Color.cyan.opacity(0.8),
                            Color.cyan.opacity(0.2),
                            .clear
                        ],
                        center: .center,
                        startRadius: size * 0.35,
                        endRadius: size * 0.6
                    ),
                    lineWidth: 6
                )
                .blur(radius: 6)

            // Glass body
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.05),
                            Color.black.opacity(0.3)
                        ],
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: size * 0.6
                    )
                )

//            EnergyWaveParticles(size: size * 0.9)
//                .clipShape(Circle())
            WaveSpiralView()
                            .frame(width: size, height: size)
                            .clipShape(Circle())   // 🔥 inti utama
        }
        .frame(width: size, height: size)
    }
}

struct EnergyWaveParticles: View {
    var size: CGFloat
    let particleCount = 280

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, canvasSize in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let centerY = canvasSize.height / 2

                for i in 0..<particleCount {
                    let progress = CGFloat(i) / CGFloat(particleCount)

                    let x = progress * canvasSize.width
                    let wave =
                    CGFloat(sin(Double(progress) * .pi * 4 + time * 1.2)) * 22 +
                        CGFloat(sin(Double(progress) * .pi * 9 - time)) * 12

                    let y = centerY + wave

                    let colorMix = progress < 0.5
                        ? Color.purple.opacity(0.8)
                        : Color.cyan.opacity(0.8)

                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: x,
                            y: y,
                            width: 2.2,
                            height: 2.2
                        )),
                        with: .color(colorMix)
                    )
                }
            }
        }
        .frame(width: size, height: size)
    }
}


struct WaveSpiralView: View {
    @State private var time: Double = 0

    var body: some View {
        Canvas { context, size in
            let centerY = size.height / 2
            let width = size.width

            let lineCount = 36
            let baseAmplitude: CGFloat = 60
            let frequency: CGFloat = 2.5

            // 🔹 Pisahkan gradient
            let colors: [Color] = [
                Color(hex: "6FA8FF").opacity(0.55),
                Color(hex: "B76BFF").opacity(0.55)
            ]

//            let gradient = LinearGradient(
//                colors: colors,
//                startPoint: .leading,
//                endPoint: .trailing
//            )
            let gradient = Gradient(colors: colors)

            for i in 0..<lineCount {
                let progress = CGFloat(i) / CGFloat(lineCount)
                let offset = progress * 35

                var path = Path()
                path.move(to: CGPoint(x: 0, y: centerY))

                for x in stride(from: 0, through: width, by: 2) {
                    let normalizedX = x / width

                    // 🔹 Pecah math expression
                    let phase = Double(progress) * 6
                    let baseAngle = Double(normalizedX * frequency * .pi * 2)
                    let animatedAngle = baseAngle + time * 1.2 + phase

                    let sine = sin(animatedAngle)
                    let amplitude = baseAmplitude - offset
                    let wave = CGFloat(sine) * amplitude

                    let y = centerY + wave
                    path.addLine(to: CGPoint(x: x, y: y))
                }

                // 🔹 Pecah stroke arguments
                let start = CGPoint(x: 0, y: 0)
                let end = CGPoint(x: width, y: 0)

                context.stroke(
                    path,
                    with: .linearGradient(
                        gradient,
                        startPoint: start,
                        endPoint: end
                    ),
                    lineWidth: 1
                )
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 8)
                .repeatForever(autoreverses: false)
            ) {
                time = .pi * 2
            }
        }
    }
}

struct NebulusHaloView: View {
    @State private var breathe = false
    @State private var time: CGFloat = 0

    var body: some View {
        ZStack {

            // 🌫 Outer Nebula
//            NebulaAura(time: time)
//                .opacity(0.35)

            // 🌕 Inner Aura (breathing body)
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "AEE2FF").opacity(0.45),
                            Color(hex: "6FA8FF").opacity(0.25),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 170
                    )
                )
                .blur(radius: 48)
//                .scaleEffect(breathe ? 1.04 : 0.97)
                .opacity(breathe ? 0.9 : 0.65)
                .animation(breathingCurve, value: breathe)

            // ✨ Core Glow (soul)
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.9),
                            .white.opacity(0.25),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 90
                    )
                )
                .blur(radius: 24)
                .scaleEffect(breathe ? 1.02 : 0.98)
        }
//        .frame(width: 320, height: 320)
        .onAppear {
            breathe.toggle()
            animateTime()
        }
    }

    // ⏳ Breathing: inhale cepat, exhale panjang
    var breathingCurve: Animation {
        .timingCurve(0.4, 0.0, 0.2, 1.0, duration: 9)
            .repeatForever(autoreverses: true)
    }

    func animateTime() {
        withAnimation(
            .linear(duration: 22)
                .repeatForever(autoreverses: false)
        ) {
            time = .pi * 2
        }
    }
}

struct NebulaAura: View {
    var time: CGFloat

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)

            for layer in 0..<5 {
                let baseRadius = size.width * (0.34 + CGFloat(layer) * 0.07)
                var path = Path()
                let points = 140

                for i in 0...points {
                    let angle = CGFloat(i) / CGFloat(points) * .pi * 2

                    // 🌊 Subtle asymmetry noise
                    let noise =
                        sin(angle * 3 + time * 0.7) * 10 +
                        cos(angle * 5 - time * 0.5) * 6 +
                        sin(angle * 9 + CGFloat(layer)) * 4

                    let radius = baseRadius + noise
                    let x = center.x + cos(angle) * radius
                    let y = center.y + sin(angle) * radius

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }

                path.closeSubpath()

                context.stroke(
                    path,
                    with: .color(
                        Color(hex: "7FAEFF")
                            .opacity(0.14 - CGFloat(layer) * 0.02)
                    ),
                    lineWidth: 1.1
                )
            }
        }
        .blur(radius: 42)
    }
}

struct StaticNebulusHalo: View {
    var body: some View {
        ZStack {

            // 🌫 Outer Aura
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "6FA8FF").opacity(0.25),
                            Color(hex: "6FA8FF").opacity(0.08),
                            .clear
                        ]),
                        center: .init(x: 0.46, y: 0.44), // subtle asymmetry
                        startRadius: 50,
                        endRadius: 170
                    )
                )
                .blur(radius: 42)

            // 🌕 Inner Glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "E6F1FF").opacity(0.95),
                            Color(hex: "A3CCFF").opacity(0.55),
                            .clear
                        ]),
                        center: .init(x: 0.52, y: 0.48),
                        startRadius: 0,
                        endRadius: 95
                    )
                )
                .blur(radius: 22)
        }
//        .frame(width: 220, height: 220)
    }
}
