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
    private var timer: Timer?
    
    
    override init(){
        super.init()
//        self.refreshVitals()
    }
    
    func refreshVitals() {
        HealthKitManager.shared.requestAuthorization { authorized in
            guard authorized else { return }

            var payload: [String: Any] = [:]
            let group = DispatchGroup()

            // HRV
            group.enter()
            HealthKitManager.shared.fetchLatestHRV { value in
                if let value {
                    payload["hrvValue"] = (value * 100).rounded() / 100
                }
                group.leave()
            }

            // Heart Rate
            group.enter()
            HealthKitManager.shared.fetchLatestHeartRate { bpm in
                if let bpm {
                    payload["heartRateValue"] = (bpm * 100).rounded() / 100
                }
                group.leave()
            }

            // Breathing Rate
            group.enter()
            HealthKitManager.shared.fetchLatestBreathingRate { rate in
                if let rate {
                    payload["breathingRateValue"] = (rate * 100).rounded() / 100
                }
                group.leave()
            }

            group.notify(queue: .main) {
                guard !payload.isEmpty else { return }
                self.sendVitalsToiPhone(payload)
                AppLogger.shared.log("📤 Queued vitals: \(payload)")
            }
        }
    }
    
    func sendVitalsToiPhone(_ data: [String: Any]) {
        WatchSessionManager.shared.send(data)
        
    }
}


final class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()

    private var pendingPayloads: [[String: Any]] = []
    private(set) var isReady = false

    private override init() {
        super.init()

        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        isReady = activationState == .activated
        print("⌚️ WCSession activated:", activationState.rawValue)

        flushPendingIfNeeded()
    }

    func send(_ data: [String: Any]) {
        guard isReady else {
            print("⏳ WCSession not ready, queue data")
            pendingPayloads.append(data)
            return
        }

        WCSession.default.transferUserInfo(data)
        print("📤 transferUserInfo sent:", data)
    }

    private func flushPendingIfNeeded() {
        guard isReady, !pendingPayloads.isEmpty else { return }

        print("🚀 Flushing pending payloads:", pendingPayloads.count)
        pendingPayloads.forEach {
            WCSession.default.transferUserInfo($0)
        }
        pendingPayloads.removeAll()
    }
}
