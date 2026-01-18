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

        var scoreCalm = 0
        var scoreAnxiety = 0
        var scoreSadness = 0
        var signalCount = 0

        // HRV
        if hrv > 0 {
            signalCount += 1
            if hrv >= 50 { scoreCalm += 2 }
            else if hrv < 30 { scoreAnxiety += 2 }
            else { scoreSadness += 1 }
        }

        // Heart Rate
        if heartRate > 0 {
            signalCount += 1
            if heartRate <= 70 { scoreCalm += 2 }
            else if heartRate >= 90 { scoreAnxiety += 2 }
            else { scoreSadness += 1 }
        }

        // Breathing Rate
        if breathingRate > 0 {
            signalCount += 1
            if breathingRate <= 12 { scoreCalm += 1 }
            else if breathingRate >= 20 { scoreAnxiety += 1 }
        }

        // Minimal data
        guard signalCount >= 2 else {
            return .unknown
        }

        // Decision
        if scoreAnxiety > scoreCalm && scoreAnxiety > scoreSadness {
            return .anxiety
        }

        if scoreCalm > scoreAnxiety && scoreCalm > scoreSadness {
            return .calm
        }

        if scoreSadness > scoreAnxiety && scoreSadness > scoreCalm {
            return .sadness
        }

        return .unknown
    }
}
