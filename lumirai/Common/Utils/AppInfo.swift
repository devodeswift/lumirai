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
}
