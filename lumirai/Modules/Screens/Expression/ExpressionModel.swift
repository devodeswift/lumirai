//
//  ExpressionModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 16/01/26.
//

import Foundation
import SwiftyJSON

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

struct templatesModel {
    var dataTemplates: [String] = []
    
    init() {}

    init(_ json: JSON) {
        dataTemplates = json["data_templates"].arrayValue.map { $0.stringValue }
    }
}

struct templatesMemoryCallbackModel {
    var dataTemplates30Days: [String] = []
    var dataTemplates90Days: [String] = []
    var dataTemplates120Days: [String] = []
    
    init() {}

    init(_ json: JSON) {
        dataTemplates30Days = json["30_days"].arrayValue.map { $0.stringValue }
        dataTemplates90Days = json["90_days"].arrayValue.map { $0.stringValue }
        dataTemplates120Days = json["120_days"].arrayValue.map { $0.stringValue }
    }
}

enum EmotionMode {
    case stress
    case fatigue
    case existential
    case none
}

struct EmotionKeywords {
    static let stress: [String] = [
        "stress",
        "stressed",
        "anxious",
        "anxiety",
        "panic",
        "worried",
        "worry",
        "overwhelmed",
        "tense",
        "nervous",
        "pressure",
        "overload",
        "afraid",
        "scared",
        "too much",
        "can’t breathe",
        "heart racing"
    ]
    
    static let fatigue: [String] = [
        "tired",
        "exhausted",
        "sleep",
        "sleepy",
        "drained",
        "weary",
        "rest",
        "heavy",
        "fatigue",
        "burnout",
        "no energy",
        "can’t focus"
    ]
    
    static let existential: [String] = [
        "why",
        "meaning",
        "purpose",
        "point",
        "lost",
        "don't know",
        "unclear",
        "confused",
        "empty",
        "rumination",
        "neutral",
        "sad",
        "empty",
        "alone",
        "lonely",
        "overthinking",
        "stuck in my head",
        "thinking too much",
        "hopeless"
    ]
}

