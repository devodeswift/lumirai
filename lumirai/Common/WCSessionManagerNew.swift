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
        print("🔥 WCSessionManagerNew INIT")
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("🔥 WCSessionManagerNew INIT support")
        }
    }


    // required stub
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("📲 WCSession activated:", activationState.rawValue)
        let session = WCSession.default

        print("isPaired:", session.isPaired)
        print("isWatchAppInstalled:", session.isWatchAppInstalled)
        print("activationState:", session.activationState.rawValue)
    }
    
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        print("📩 UserInfo test received:", userInfo)
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
