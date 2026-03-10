//
//  BreathingEngine.swift
//  lumirai
//
//  Created by dana nur fiqi on 09/03/26.
//

import Foundation

class BreathingEngine {
    let hr: Double = AppUserDefaults.shared.hearRate
    let hrv: Double = AppUserDefaults.shared.hrv
    
    private var getDurationInHale: Double{
        if hr > 80 && hrv < 30 {
            //agitated
            return 6.0 * 0.42
        } else if hr < 65 && hrv > 60 {
            // Calm
            return 5.0 * 0.42
        } else if hrv < 40 {
            // fatigue
            return 5.5 * 0.42
        } else {
            return 5.0 * 0.42
        }
    }
    
    private var getDurationExHale: Double{
        if hr > 80 && hrv < 30 {
            return 6.0 * 0.58
        } else if hr < 65 && hrv > 60 {
            return 5.0 * 0.58
        } else if hrv < 40 {
            return 5.5 * 0.58
        } else {
            return 5.0 * 0.58
        }
    }
    
    
    func inhaleDuration() -> Double {
        AppSettings.shared.jitter(getDurationInHale)
    }

    func exhaleDuration() -> Double {
        AppSettings.shared.jitter(getDurationInHale)
    }
    
}
