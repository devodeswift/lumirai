//
//  GlassButtonView.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import SwiftUI

struct GlassButtonView: View {
    var title: String = ""
    
    // Custom colors
    var textColor: Color? = nil
    var glassTint: Color? = nil
    var glowColor: Color? = nil
    
    // ✅ Background mode (default glass)
    var backgroundStyle: GlassButtonBackground = .glass
    
    var action: () -> Void = {}

    private let cornerRadius: CGFloat = 14
    private let defaultText = Color("#EAF6F5")
    private let defaultGlassTint = Color.black.opacity(0.22)
    private let defaultGlow = Color.white

    @State private var isPressed = false

    private func performHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
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
                .foregroundColor(textColor ?? defaultText)
                .padding(.vertical, 14)
                .padding(.horizontal, 26)
                .frame(maxWidth: .infinity)
        }
        .background(backgroundView)
        .overlay(borderView)
        .overlay(glowView)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)
        .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 0)
        .scaleEffect(isPressed ? 0.985 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.30)) {
                        isPressed = false
                    }
                }
        )
        .padding(8)
    }
}

private extension GlassButtonView {

    @ViewBuilder
    var backgroundView: some View {
        switch backgroundStyle {
        case .glass:
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(glassTint ?? defaultGlassTint)
                    .blur(radius: 10)

                BlurView(style: .systemUltraThinMaterialDark)
                    .cornerRadius(cornerRadius)
            }

        case .solid(let color):
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
        }
    }

    var borderView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(Color.white.opacity(0.18), lineWidth: 0.8)
    }

    var glowView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill((glowColor ?? defaultGlow).opacity(isPressed ? 0.12 : 0))
            .blur(radius: 12)
            .animation(.easeOut(duration: 0.15), value: isPressed)
    }
}

enum GlassButtonBackground {
    case glass
    case solid(Color)
}
#Preview {
    VStack{
        GlassButtonView(title: "test"){
            
        }
        GlassButtonImageView(image: Image(systemName: "chevron.left")){
            
        }
        .frame(width: 70)
    }
    
}

// GlassButton image
struct GlassButtonImageView: View {
    var image: Image
    
    var textColor: Color? = nil
    var glassTint: Color? = nil
    var glowColor: Color? = nil
    var backgroundStyle: GlassButtonBackground = .glass
    var action: () -> Void = {}

    private let cornerRadius: CGFloat = 14
    private let defaultGlassTint = Color.black.opacity(0.22)
    private let defaultGlow = Color.white

    @State private var isPressed = false

    private func performHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    @ViewBuilder
    var backgroundView: some View {
        switch backgroundStyle {
        case .glass:
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(glassTint ?? defaultGlassTint)
                    .blur(radius: 10)

                BlurView(style: .systemUltraThinMaterialDark)
                    .cornerRadius(cornerRadius)
            }

        case .solid(let color):
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
        }
    }

    var borderView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(Color.white.opacity(0.18), lineWidth: 0.8)
    }

    var glowView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill((glowColor ?? defaultGlow).opacity(isPressed ? 0.12 : 0))
            .blur(radius: 12)
            .animation(.easeOut(duration: 0.15), value: isPressed)
    }

    var body: some View {
        Button(action: {
            performHaptic()
            action()
        }) {
            image
                .resizable()
                .scaledToFit()
                .frame(height: 22)
                .foregroundColor(textColor ?? .white)
                .padding(.vertical, 14)
                .padding(.horizontal, 26)
                .frame(maxWidth: .infinity)
        }
        .background(backgroundView)
        .overlay(borderView)
        .overlay(glowView)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .scaleEffect(isPressed ? 0.985 : 1)
        .animation(.easeOut(duration: 0.15), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}
