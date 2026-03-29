//
//  RadioButtonView.swift
//  lumirai
//
//  Created by dana nur fiqi on 11/03/26.
//

import Foundation
import SwiftUI
struct RadioButtonView: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    @State private var pulse = false

    var body: some View {
        Button(action: {
            action()
            triggerPulse()
        }) {
            HStack(spacing: 12) {
                // Radio circle
                Circle()
                    .stroke(isSelected ? Color.blue.opacity(0.6) : Color.gray , lineWidth: 1)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : .clear)
                            .padding(4)
                    )
                    .frame(width: 22, height: 22)

                Text(title)
                    .font(AppFonts.playFairDisplayReg(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.blue.opacity(isSelected ? 0.35 : 0.08), lineWidth: 1)
        )

        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.blue.opacity(pulse ? 0.3 : 0), lineWidth: 2)
                .blur(radius: 14)
                .scaleEffect(pulse ? 1.06 : 1.0)
                .opacity(pulse ? 1 : 0)
        )
        .animation(.easeOut(duration: 0.22), value: pulse)
    }

    private func triggerPulse() {
        pulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            pulse = false
        }
    }
}
