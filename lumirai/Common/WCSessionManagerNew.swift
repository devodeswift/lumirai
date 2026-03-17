//
//  WCSessionManagerNew.swift
//  lumirai
//
//  Created by dana nur fiqi on 06/01/26.
//

import Foundation
import WatchConnectivity
import Combine

final class WCSessionManagerNew: NSObject, WCSessionDelegate, ObservableObject {
    func sessionDidBecomeInactive(_ session: WCSession) {
        AppLogger.shared.log("📡 WCSession didBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        AppLogger.shared.log("📡 WCSession didDeactivate")
        WCSession.default.activate()
    }
    
    static let shared = WCSessionManagerNew()

    @Published var hrv: Double?

    private override init() {
        super.init()
        AppLogger.shared.log("🔥 WCSessionManagerNew INIT")
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            AppLogger.shared.log("🔥 WCSessionManagerNew INIT support")
        }
    }


    // required stub
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        AppLogger.shared.log("📲 WCSession activated: \(activationState.rawValue)")
        let session = WCSession.default

        AppLogger.shared.log("isPaired: \(session.isPaired)")
        AppLogger.shared.log("isWatchAppInstalled: \(session.isWatchAppInstalled)")
        AppLogger.shared.log("activationState: \(session.activationState.rawValue)")
        AppLogger.shared.log("reachable: \(session.isReachable)")
    }
    
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        AppLogger.shared.log("📩 UserInfo test received: \(userInfo)")
        let hrv = userInfo["hrvValue"] as? Double
        let heartRate = userInfo["heartRateValue"] as? Double
        let breathingRate = userInfo["breathingRateValue"] as? Double
        
        if let hrv {
            AppUserDefaults.shared.hrv = hrv
            AppLogger.shared.log("❤️ HRV: \(hrv)")
        }
        
        if let heartRate {
            AppUserDefaults.shared.hearRate = heartRate
            AppLogger.shared.log("💓 Heart Rate (BPM): \(heartRate)")
        }
        
        if let breathingRate {
            AppUserDefaults.shared.breathRate = breathingRate
            AppLogger.shared.log("🫁 Breathing Rate: \(breathingRate)")
        }
    }
}
