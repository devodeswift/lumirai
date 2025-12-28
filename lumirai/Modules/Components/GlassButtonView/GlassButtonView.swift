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

    private let aqua = Color("#EAF6F5")
    private let cornerRadius: CGFloat = 14
    private let borderWidth: CGFloat = 1

    // Haptic
    private func performHaptic() {
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
