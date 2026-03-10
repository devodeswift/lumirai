//
//  AppInfo.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation

class AppInfo {
    static let shared = AppInfo()
    
    var getAppVersion : String {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return version
    }
    
    var getDurationInHale: Double{
        let hr: Double = AppUserDefaults.shared.hearRate
        let hrv: Double = AppUserDefaults.shared.hrv
        
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
    
    var getDurationExHale: Double{
        let hr: Double = AppUserDefaults.shared.hearRate
        let hrv: Double = AppUserDefaults.shared.hrv
        
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

}
