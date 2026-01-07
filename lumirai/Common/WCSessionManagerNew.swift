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
        print("📡 WCSession didBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("📡 WCSession didDeactivate")
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

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String : Any]
    ) {
        print("📩 Message received:", message)
        if let hrv = message["hrv"] as? Double {
            DispatchQueue.main.async {
                print("❤️ HRV set:", hrv)
                self.hrv = hrv
            }
        }
    }

    // required stub
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}
    
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        print("📩 UserInfo received:", userInfo)

        if let hrv = userInfo["hrv"] as? Double {
            DispatchQueue.main.async {
                print("❤️ HRV set:", hrv)
                self.hrv = hrv
            }
        }
    }
}
