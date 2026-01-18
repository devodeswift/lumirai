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
    
    
}
