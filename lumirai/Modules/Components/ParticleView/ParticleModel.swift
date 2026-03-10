//
//  ParticleModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 10/03/26.
//

import Foundation

struct ParticleModel: Identifiable {
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
            return maxOpacity * (t / 0.2)
        case 0.2..<0.8:
            return maxOpacity
        default:
            return maxOpacity * (1 - (t - 0.8) / 0.2)  
        }
    }

    var isAlive: Bool {
        Date().timeIntervalSince(birth) < lifespan
    }
}
