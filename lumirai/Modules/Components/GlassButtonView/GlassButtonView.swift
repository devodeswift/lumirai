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
    var action: () -> Void

    private let cornerRadius: CGFloat = 14
    
    @State private var isPressed = false

    // Haptic
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
                .foregroundColor(Color("#EAF6F5"))
                .padding(.vertical, 14)
                .padding(.horizontal, 26)
                .frame(maxWidth: .infinity)
        }
        .background(
            ZStack {
                // Depth layer
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.black.opacity(0.22))
                    .blur(radius: 10)
                
                // Glass material
                BlurView(style: .systemUltraThinMaterialDark)
                    .cornerRadius(cornerRadius)
            }
        )
        .overlay(
            ZStack {
                // Border glass
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.18), lineWidth: 0.8)
                
                // Inner subtle highlight
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    .blur(radius: 1.5)
            }
        )
        // Micro glow on press
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white.opacity(isPressed ? 0.12 : 0))
                .blur(radius: 12)
                .animation(.easeOut(duration: 0.15), value: isPressed)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        
        // Subtle depth shadow
        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 6)
        .shadow(color: Color.white.opacity(0.12), radius: 1, x: 0, y: 0)
        
        // Gesture tracking for tactile feel
        .scaleEffect(isPressed ? 0.985 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isPressed)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.30)) {
                        isPressed = false
                    }
                }
        )
        .padding(8)
    }
}

#Preview {
    GlassButtonView(title: "test"){
        
    }
}
