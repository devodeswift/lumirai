//
//  WelcomeViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import Combine
import WatchConnectivity

class WelcomeViewModel: BaseViewModel, WCSessionDelegate{
    @Published var audio = AudioManager()
    @Published var audioBreath = AudioManager()
    @Published var letters: [String] = ["L", "U", "M", "I", "R", "A", "i"]
    @Published var txtTittleTop: String = "Silence that holds you."
    @Published var txtTittleBot: String = "Luxury is no longer gold. It's inner peace."
    @Published var textButton: String = "enter the calm"
    @Published var isLoggingIn: Bool = false
    
    override func start() {
        super.start()
        cekLoggingIn()
    }
    
    func cekLoggingIn() {
        if AppUserDefaults.shared.isLoggedIn {
            isLoggingIn = true
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("📲 WCSession activated:", activationState.rawValue)
        let session = WCSession.default

        print("isPaired:", session.isPaired)
        print("isWatchAppInstalled:", session.isWatchAppInstalled)
        print("activationState:", session.activationState.rawValue)
    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }
    
//    func session(
//        _ session: WCSession,
//        didReceiveUserInfo userInfo: [String : Any]
//    ) {
//        print("📩 UserInfo received:", userInfo)
//
//        if let hrv = userInfo["test"] as? Double {
//            DispatchQueue.main.async {
//                print("📩 UserInfo received:", userInfo)
//            }
//        }
//    }
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        print("📩 UserInfo received:", userInfo)

        let hrv = userInfo["hrvValue"] as? Double
        let heartRate = userInfo["heartRateValue"] as? Double
        let breathingRate = userInfo["breathingRateValue"] as? Double

        DispatchQueue.main.async {
            print("❤️ HRV:", hrv ?? 0.0)
            print("💓 Heart Rate:", heartRate ?? 0.0)
            print("🫁 Breathing Rate:", breathingRate ?? 0.0)
        }
    }
    
}
