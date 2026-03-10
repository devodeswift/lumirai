//
//  AppSettings.swift
//  lumirai
//
//  Created by dana nur fiqi on 09/03/26.
//

import Foundation

class AppSettings {
    static let shared = AppSettings()
    
    var isUsageUpdatedToday: Bool {
        guard let lastDate = AppUserDefaults.shared.lastUsageUpdateDate else { return false }
        AppLogger.shared.log("lastUsageUpdateDate: \(lastDate)")
        return Calendar.current.isDateInToday(lastDate)
    }
    
    func updateUsageCountIfNeeded() {
        guard !isUsageUpdatedToday else { return }

        AppUserDefaults.shared.usageCountPerDay += 1
        AppUserDefaults.shared.lastUsageUpdateDate = Date()
    }
    
    func jitter(_ base: Double, percent: Double = 0.08) -> Double {
        let delta = base * percent
        return base + Double.random(in: -delta...delta)
    }
    
    
}
