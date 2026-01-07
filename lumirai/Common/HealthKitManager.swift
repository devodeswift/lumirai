//
//  HealthKitManager.swift
//  lumirai
//
//  Created by dana nur fiqi on 06/01/26.
//

import Foundation
import WatchConnectivity
import Combine

final class WCSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("📡 WCSession didBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("📡 WCSession didDeactivate")
            WCSession.default.activate()
    }
    
    static let shared = WCSessionManager()

    @Published var latestHRV: Double?

    private override init() {
        super.init()

        guard WCSession.isSupported() else { return }

        let session = WCSession.default
        session.delegate = self
        session.activate()

        print("📡 WCSession activated (iOS)")
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("📡 iOS activation state:", activationState.rawValue)
        AppLogger.shared.log("cek value hrv ios \(activationState.rawValue)")
    }

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        print("📩 Message received:", message)

        if let hrv = message["hrv"] as? Double {
            DispatchQueue.main.async {
                self.latestHRV = hrv
            }
        }
    }
}


