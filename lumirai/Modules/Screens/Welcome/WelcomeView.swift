//
//  WelcomeView.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import SwiftUI
import Combine

struct WelcomeView: View {
    @State private var animate = false
    @State private var visibleCount: Int = 0
    @State private var showLetter = false
    @State private var showSubtitle: Bool = false
    @State private var showParticles = false
    @State private var showButton = false
    @StateObject var audio = AudioManager()
    @StateObject var audioBreath = AudioManager()
    let letters: [String] = ["L", "U", "M", "I", "R", "A", "i"]
    @State private var goToExpression = false
    
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Color("#0A0F16").ignoresSafeArea()
                bigHaloBreathing()
                if showParticles {
                    ParticleShimmer()
                        .allowsHitTesting(false)
                }
                VStack{
                    if showLetter {
                        sequentialFadeText(letters: letters)
                    }
                    Spacer()
                        .frame(height: 20)
                    if showSubtitle {
                        VStack(spacing: 4) {
                            Text("Silence that holds you.")
                                .font(AppFonts.playFairDisplayReg(size: 18))
                                .foregroundColor(Color("#EAF6F5"))
                                .opacity(showSubtitle ? 1 : 0)
                            Text("Luxury is no longer gold. It's inner peace.")
                                .font(AppFonts.playFairDisplayReg(size: 18))
                                .foregroundColor(Color("#EAF6F5"))
                                .opacity(showSubtitle ? 1 : 0)
                        }
                        .multilineTextAlignment(.center)
                    }
                    Spacer()
                        .frame(height: 98)
                    if showButton {
                        GlassButton {
                            goToExpression = true
                        }
                        .scaleEffect(animate ? 1.02 : 0.98)
                        .opacity(animate ? 1.02 : 0.98)
                        .animation(
                            Animation.easeInOut(duration: 6.0)
                                .repeatForever(autoreverses: true),
                            value: showButton
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(isPresented: $goToExpression) {
                ExpressionView()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
//                if let url = Bundle.main.url(forResource: "soft-breath", withExtension: "mp3") {
//                    audioBreath.playWithFadeIn(url: url, duration: 0.1)
//                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    audioBreath.stopWithFadeOut(duration: 0.5)
                    if let url = Bundle.main.url(forResource: "ambient", withExtension: "mp3") {
                        audio.playWithFadeIn(url: url, duration: 0.1)
                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
//                        audio.stopWithFadeOut(duration: 0.1)
//                    }
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showLetter = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.38) {
                        withAnimation(.easeInOut(duration: 1.22)) {
                            showSubtitle = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 1.3)) {
                            showParticles = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeInOut(duration: 1.4)) {
                            showButton = true
//                            if let url = Bundle.main.url(forResource: "soft-breath", withExtension: "mp3") {
//                                audioBreath.playWithFadeIn(url: url, duration: 2)
//                            }
                            audio.stopWithFadeOut(duration: 2)
                        }
                    }
                }
//            }
        }
    }
    
    func bigHaloBreathing() -> some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color("#00C4B4"),
                        Color("#5648A8"),
                        Color("#F5E9C5")
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 240
                )
            )
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .blur(radius: 70)
            .scaleEffect(animate ? 1.15 : 0.95)
            .opacity(animate ? 0.9 : 0.4)
            .animation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
    
    func sequentialFadeText(letters: [String]) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<letters.count, id: \.self) { index in
                Text(letters[index])
                    .font(AppFonts.playFairDisplayReg(size: 28))
                    .foregroundColor(Color("#EAF6F5"))
                    .opacity(visibleCount > index ? 1 : 0)
                    .animation(.easeOut(duration: 0.30).delay(Double(index) * 0.18), value: visibleCount)
            }
        }
        .onAppear {
            visibleCount = letters.count   // trigger the fade sequence
        }
        
    }
}


struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
}

struct ParticleShimmer: View {
    @State private var particles: [Particle] = []
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(particles) { p in
                Circle()
                    .fill(Color.white.opacity(1.5))
                    .frame(width: p.size, height: p.size)
                    .position(x: p.x, y: p.y)
                    .opacity(animate ? 0.2 : 0.5)
                    .scaleEffect(animate ? 0.2 : 0.8)
            }
        }
        .onAppear {
            spawnParticles()
            withAnimation(
                .easeInOut(duration: 18)
                .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
    
    private func spawnParticles() {
        for _ in 0..<12 {
            particles.append(
                Particle(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                    size: CGFloat.random(in: 1...2),
                )
            )
        }
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: effect)
        view.clipsToBounds = true
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // no-op
    }
}

struct GlassButton: View {
    var title: String = "enter the calm"
    var action: () -> Void

    // Colors
    private let aqua = Color("#EAF6F5")
    private let cornerRadius: CGFloat = 14
    private let borderWidth: CGFloat = 1

    // Haptic
    private func performHaptic() {
        // medium impact for tactile feel
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    var body: some View {
        Button(action: {
            performHaptic()
            action()
        }) {
            Text(title)
                .font(AppFonts.nunito(size: 16))
                .foregroundColor(Color("#EAF6F5"))
                .padding(.vertical, 14)
                .padding(.horizontal, 26)
                .frame(minWidth: 160)
        }
        .background(
            ZStack {
                Color.black.opacity(0.18)
                    .blur(radius: 8)
                    .cornerRadius(cornerRadius)
                // Blur layer
                BlurView(style: .systemUltraThinMaterialDark)
                    .cornerRadius(cornerRadius)
                    .opacity(1.0)
            }
        )
        .overlay(
            ZStack {
                // (C) Border 0.5–0.8 px, white 20%
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.20), lineWidth: 0.7)
                            
                // (B) Inner shadow 1–2 px
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    .blur(radius: 1.6)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .opacity(0.6)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: Color.white.opacity(0.13), radius: 2, x: 0, y: 0)
        .compositingGroup()
        .padding(8)
    }
}

#Preview {
    WelcomeView()
}
