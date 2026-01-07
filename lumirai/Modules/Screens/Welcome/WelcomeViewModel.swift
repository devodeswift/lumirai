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
    
    override func start() {
        super.start()
        print("🔥 WelcomeViewModel start() CALLED")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String : Any]
    ) {
        print("📩 UserInfo received:", userInfo)

        if let hrv = userInfo["test"] as? Double {
            DispatchQueue.main.async {
                print("📩 UserInfo received:", userInfo)
            }
        }
    }
    
}
