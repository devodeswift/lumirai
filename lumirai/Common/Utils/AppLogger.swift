//
//  AppLogger.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import UIKit
import os

class AppLogger {
    static let shared = AppLogger()
    
    private init() {}
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "CentralLogger")
    
    func log(_ message: String, file: String = #fileID, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let formatted = "🐛 DEBUG [\(fileName):\(line)] : \(message)"
        logger.debug("\(formatted)")
    }
    
}
