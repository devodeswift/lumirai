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
}
