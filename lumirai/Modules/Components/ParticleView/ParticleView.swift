//
//  ParticleView.swift
//  lumirai
//
//  Created by dana nur fiqi on 10/03/26.
//

import Foundation
import SwiftUI
import Combine



struct ParticleView: View {
    @State private var particles: [ParticleModel] = []
    @State private var now: Date = .now

    @Binding var animate: Bool

    var countParticles: Int = 80

    let timer = Timer.publish(every: 1 / 30, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { p in
                    Circle()
                        .fill(Color.white)
                        .frame(width: p.size, height: p.size)
                        .position(p.position(at: now))
                        .opacity(p.opacity(at: now))
                }
            }
            .onAppear {
                spawn(in: geo.size)
            }
            .onReceive(timer) { time in
                now = time
                recycleParticlesIfNeeded(in: geo.size)
            }
        }
    }
}

private extension ParticleView {
    
    func spawn(in size: CGSize) {
        particles = (0..<countParticles).map { _ in
            makeParticle(in: size)
        }
    }

    func recycleParticlesIfNeeded(in size: CGSize) {
        particles = particles.map {
            $0.isAlive ? $0 : makeParticle(in: size)
        }
    }
    
    func makeParticle(in size: CGSize) -> ParticleModel {
        let angle = Double.random(in: 0...(2 * .pi))
        let dir = CGVector(dx: cos(angle), dy: sin(angle))

        return ParticleModel(
            origin: CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            ),
            direction: dir,
            speed: CGFloat.random(in: 6...12),
            size: CGFloat.random(in: 1...2),
            maxOpacity: Double.random(in: 0.2...0.5),
            lifespan: Double.random(in: 6...10),
            birth: .now
        )
    }
}
