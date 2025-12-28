//
//  ParticleShimmerView.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import SwiftUI

struct ParticleShimmerView: View {
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
