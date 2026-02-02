//
//  ParticleShimmerView.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import SwiftUI
import Combine

struct ParticleShimmerView: View {
    @State private var particles: [Particle] = []
    @State private var animate = false
    var countParticles: Int = 12
    
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
        for _ in 0..<countParticles {
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

//PARTICLE
//struct ParticleShimmerViewNew: View {
//    @State private var particles: [ParticleNew] = []
//    @Binding var animate: Bool
//    @Binding var scale: CGFloat
//    var countParticles: Int = 12
//    
//    var body: some View {
//        GeometryReader { geo in
//            ZStack {
//                ForEach(particles) { p in
//                    Circle()
//                        .fill(Color.white)
//                        .frame(width: p.size, height: p.size)
//                        .position(p.position)
//                        .offset(
//                            x: animate ? p.drift.width : -p.drift.width,
//                            y: animate ? p.drift.height : -p.drift.height
//                        )
//                        .opacity(animate ? 0.2 : 0.5)
//                        .scaleEffect(scale)
//                        .animation(
//                                    .easeInOut(duration: Double.random(in: 6...12))
//                                        .repeatForever(autoreverses: true),
//                                    value: animate
//                                )
//                }
//            }
//            .onAppear {
//                spawnParticles(in: geo.size)
//            }
//        }
//    }
//    
//    private func spawnParticles(in size: CGSize) {
//        let center = CGPoint(
//            x: size.width / 2,
//            y: size.height / 2
//        )
//        
//        particles = (0..<countParticles).map { _ in
//            ParticleNew(
//                position: CGPoint(
//                    x: center.x + CGFloat.random(in: -size.width/2 ... size.width/2),
//                    y: center.y + CGFloat.random(in: -size.height/2 ... size.height/2)
//                ),
//                size: CGFloat.random(in: 1...2),
//                opacity: CGFloat.random(in: 0.2...0.5),
//                drift: CGSize(
//                    width: CGFloat.random(in: -6...6),
//                    height: CGFloat.random(in: -6...6)
//                )
//            )
//        }
//    }
//}
//
//struct ParticleNew: Identifiable {
//    let id = UUID()
//    var position: CGPoint
//    var size: CGFloat
//    var opacity: Double
//    var drift: CGSize
//}

struct ParticleNew: Identifiable {
    let id = UUID()

    let origin: CGPoint
    let direction: CGVector
    let speed: CGFloat

    let size: CGFloat
    let maxOpacity: Double
    let lifespan: Double
    let birth: Date

    func progress(at time: Date) -> Double {
        let elapsed = time.timeIntervalSince(birth)
        return min(max(elapsed / lifespan, 0), 1)
    }

    func position(at time: Date) -> CGPoint {
        let t = progress(at: time)
        return CGPoint(
            x: origin.x + direction.dx * speed * t,
            y: origin.y + direction.dy * speed * t
        )
    }

    func opacity(at time: Date) -> Double {
        let t = progress(at: time)

        switch t {
        case 0..<0.2:
            return maxOpacity * (t / 0.2)              // fade in
        case 0.2..<0.8:
            return maxOpacity                           // sustain
        default:
            return maxOpacity * (1 - (t - 0.8) / 0.2)  // fade out
        }
    }

    var isAlive: Bool {
        Date().timeIntervalSince(birth) < lifespan
    }
}

struct ParticleShimmerViewNew: View {
    @State private var particles: [ParticleNew] = []
    @State private var now: Date = .now

    @Binding var animate: Bool
    @Binding var scale: CGFloat

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
                        .scaleEffect(scale)
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

private extension ParticleShimmerViewNew {

//    func spawn(in size: CGSize) {
//        let center = CGPoint(x: size.width / 2, y: size.height / 2)
//        let radius = min(size.width, size.height) * 0.12
//
//        particles = (0..<countParticles).map { _ in
//            makeParticle(center: center, radius: radius)
//        }
//    }
//
//    func recycleParticlesIfNeeded(in size: CGSize) {
//        let center = CGPoint(x: size.width / 2, y: size.height / 2)
//        let radius = min(size.width, size.height) * 0.12
//
//        particles = particles.map {
//            $0.isAlive ? $0 : makeParticle(center: center, radius: radius)
//        }
//    }

//    func makeParticle(center: CGPoint, radius: CGFloat) -> ParticleNew {
//        let angle = Double.random(in: 0...(2 * .pi))
//        let dir = CGVector(dx: cos(angle), dy: sin(angle))
//
//        return ParticleNew(
//            origin: CGPoint(
//                x: center.x + CGFloat.random(in: -radius...radius),
//                y: center.y + CGFloat.random(in: -radius...radius)
//            ),
//            direction: dir,
//            speed: CGFloat.random(in: 10...18),
//            size: CGFloat.random(in: 1...2),
//            maxOpacity: Double.random(in: 0.2...0.5),
//            lifespan: Double.random(in: 6...10),
//            birth: .now
//        )
//    }
    
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
    
    func makeParticle(in size: CGSize) -> ParticleNew {
        let angle = Double.random(in: 0...(2 * .pi))
        let dir = CGVector(dx: cos(angle), dy: sin(angle))

        return ParticleNew(
            origin: CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            ),
            direction: dir,
            speed: CGFloat.random(in: 6...12),   // pelan biar gak keluar cepat
            size: CGFloat.random(in: 1...2),
            maxOpacity: Double.random(in: 0.2...0.5),
            lifespan: Double.random(in: 6...10),
            birth: .now
        )
    }
}
