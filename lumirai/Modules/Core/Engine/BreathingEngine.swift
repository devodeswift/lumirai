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
    
    var onUpdate: ((Double, Double, Double) -> Void)?
    
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
        AppSettings.shared.jitter(getDurationExHale)
    }
    
    func inhale() {
        let duration = self.inhaleDuration()

        let scale = AppSettings.shared.jitter(0.96, percent: 0.06)
        let coreOpacity = AppSettings.shared.jitter(0.76, percent: 0.05)
        
        AppLogger.shared.log("cek Scale inhale: \(scale)")
        AppLogger.shared.log("cek coreOpacity inhale: \(coreOpacity)")

        onUpdate?(scale, coreOpacity, duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.exhale()
        }
    }
    
    func exhale() {
        let duration = self.exhaleDuration()
        
        let scale = AppSettings.shared.jitter(1.15, percent: 0.04)
        let coreOpacity = AppSettings.shared.jitter(0.88, percent: 0.04)
        
        AppLogger.shared.log("cek Scale exhale: \(scale)")
        AppLogger.shared.log("cek coreOpacity exhale: \(coreOpacity)")
        
        onUpdate?(scale, coreOpacity, duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.inhale()
        }
    }
    
}
