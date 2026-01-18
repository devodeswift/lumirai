//
//  ExpressionModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 16/01/26.
//

import Foundation

enum EmotionState {
    case calm
    case sadness
    case anxiety
    case unknown
}

struct EmotionEngine {

    static func detectEmotion(
        hrv: Double,
        heartRate: Double,
        breathingRate: Double
    ) -> EmotionState {
        
//        Calm
//        HRV ≥ 60
//        HR ≤ 75
//        BR ≤ 14
        
//        Anxiety
//        HRV ≤ 40
//        HR ≥ 85
//        BR ≥ 18
        
//        Sadness
//        HRV ≤ 45
//        HR ≤ 70
//        BR normal / Slow

        var availableSignals = 0

        let hasHRV = hrv > 0
        let hasHR = heartRate > 0
        let hasBR = breathingRate > 0

        if hasHRV { availableSignals += 1 }
        if hasHR { availableSignals += 1 }
        if hasBR { availableSignals += 1 }

        // Minimal data
        guard availableSignals >= 2 else {
            return .unknown
        }

        // 1️⃣ CLEAR ANXIETY
        if hasHRV && hasHR {
            if hrv < 40 && heartRate >= 85 {
                return .anxiety
            }
        }

        if hasHR && hasBR {
            if heartRate >= 90 && breathingRate >= 18 {
                return .anxiety
            }
        }

        // 2️⃣ CLEAR CALM
        if hasHRV && hasHR {
            if hrv >= 60 && heartRate <= 75 {
                return .calm
            }
        }

        if hasBR && breathingRate <= 12 {
            return .calm
        }

        // 3️⃣ SADNESS / LOW ENERGY
        if hasHRV && hrv < 45 {
            return .sadness
        }

        if hasHR && heartRate < 70 {
            return .sadness
        }

        // 4️⃣ FALLBACK (deterministic)
        if hasHRV {
            return hrv >= 55 ? .calm : .sadness
        }

        if hasHR {
            return heartRate >= 85 ? .anxiety : .sadness
        }

        return .unknown
    }
}

struct LastUserText: Codable {
    let text: String
    let savedAt: Date
}

