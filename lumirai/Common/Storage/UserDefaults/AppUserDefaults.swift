//
//  AppUserDefaults.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/01/26.
//

import Foundation

class AppUserDefaults {
    static let shared = AppUserDefaults()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    var isLoggedIn: Bool {
        get {
            defaults.bool(forKey: KeysAppUserDefaults.isLoggedIn)
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.isLoggedIn)
        }
    }
    
    var hrv: Double {
        get {
            defaults.double(forKey: KeysAppUserDefaults.hrv)
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.hrv)
        }
    }
    
    var hearRate: Double {
        get {
            defaults.double(forKey: KeysAppUserDefaults.heartRate)
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.heartRate)
        }
    }
    
    var breathRate: Double {
        get {
            defaults.double(forKey: KeysAppUserDefaults.breathingRate)
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.breathingRate)
        }
    }
    
    var usageCountPerDay: Int {
        get {
            defaults.integer(forKey: KeysAppUserDefaults.usageCountPerDay)
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.usageCountPerDay)
        }
    }
    
    var lastUsageUpdateDate: Date? {
        get {
            return defaults.object(forKey: KeysAppUserDefaults.lastUsageUpdateDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.lastUsageUpdateDate)
        }
    }
    
    var lastUserTexts: [LastUserText] {
        get {
            guard
                let data = defaults.data(forKey: KeysAppUserDefaults.lastUserText),
                let values = try? JSONDecoder().decode([LastUserText].self, from: data)
            else {
                return []
            }

            let now = Date()
            let validTexts = values.filter {
                now.timeIntervalSince($0.savedAt) <= 48 * 60 * 60
            }

            // 🔥 cleanup kalau ada yang expired
            if validTexts.count != values.count {
                if let data = try? JSONEncoder().encode(validTexts) {
                    defaults.set(data, forKey: KeysAppUserDefaults.lastUserText)
                }
            }

            return validTexts
        }

        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: KeysAppUserDefaults.lastUserText)
            }
        }
    }
    
    func appendLastUserText(_ text: String) {
        var current = lastUserTexts
        current.append(
            LastUserText(
                text: text,
                savedAt: Date()
            )
        )
        lastUserTexts = current
    }
    
    var textResultCountPerDay: String {
        get {
            defaults.string(forKey: KeysAppUserDefaults.textResultCountPerday) ?? ""
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.textResultCountPerday)
        }
    }
    
    var textResultHour: String {
        get {
            defaults.string(forKey: KeysAppUserDefaults.textResultHour) ?? ""
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.textResultHour)
        }
    }
    var textResultEmotion: String {
        get {
            defaults.string(forKey: KeysAppUserDefaults.textResultEmotion) ?? ""
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.textResultEmotion)
        }
    }
    var lastEmotionState: String {
        get {
            defaults.string(forKey: KeysAppUserDefaults.lastEmotionState) ?? ""
        }
        set {
            defaults.set(newValue, forKey: KeysAppUserDefaults.lastEmotionState)
        }
    }
    
    func getLastUserTexts(for key: String) -> [LastUserText] {
        
        guard
            let data = defaults.data(forKey: key),
            let values = try? JSONDecoder().decode([LastUserText].self, from: data)
        else {
            return []
        }

        let cutoff = Date().addingTimeInterval(-48 * 60 * 60)

        let validTexts = values.filter {
            $0.savedAt >= cutoff
        }

        // cleanup expired
        if validTexts.count != values.count {
            if let data = try? JSONEncoder().encode(validTexts) {
                defaults.set(data, forKey: key)
            }
        }

        return validTexts
    }
    
    func setLastUserTexts(_ values: [LastUserText], for key: String) {
        if let data = try? JSONEncoder().encode(values) {
            defaults.set(data, forKey: key)
        }
    }
    
    func appendLastUserText(_ text: String, for key: String) {
        var current = getLastUserTexts(for: key)

        current.append(
            LastUserText(
                text: text,
                savedAt: Date()
            )
        )

        setLastUserTexts(current, for: key)
    }
    
}
