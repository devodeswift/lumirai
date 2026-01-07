//
//  HRVWatchViewModel.swift
//  lumirai-watch Watch App
//
//  Created by dana nur fiqi on 06/01/26.
//

import Foundation
import SwiftUI
import WatchConnectivity
import Combine

class WelcomeViewModel: BaseViewModel {
    @Published var hrv: Double = 0.0
    private var timer: Timer?
    
    
    override func start() {
        refreshHRV()
        
    }

    func refreshHRV() {
            HealthKitManager.shared.requestAuthorization { authorized in
                guard authorized else { return }
                var session = WCSessionManager.shared

                HealthKitManager.shared.fetchLatestHRV { value in
                    guard let value else { return }

                    DispatchQueue.main.async {
                        self.hrv = value
//                        WCSessionManager.shared.sendHRV(value)
                        self.sendHRVToiPhone(30)
                        AppLogger.shared.log("cek value hrv \(value)")
                    }
                }
            }
        }
    
    func sendHRVToiOS(_ value: Double) {
        let session = WCSession.default

        guard session.isReachable else {
            print("❌ iOS not reachable")
            return
        }

//        session.sendMessage(
//            ["hrv": value],
//            replyHandler: nil
//        ) { error in
//            print("❌ Send error:", error)
//        }
        
        session.transferUserInfo([
            "hrv": hrv
        ])

        print("✅ HRV sent:", value)
    }
    
    func sendHRVToiPhone(_ value: Double) {
        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.transferUserInfo([
            "test": hrv
        ])

        print("📤 HRV sent (transferUserInfo):", hrv)
    }
}
