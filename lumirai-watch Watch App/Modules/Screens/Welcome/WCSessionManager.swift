//
//  WCSessionManager.swift
//  lumirai-watch Watch App
//
//  Created by dana nur fiqi on 06/01/26.
//

import Foundation
import WatchConnectivity

final class WCSessionManager: NSObject, WCSessionDelegate {

    static let shared = WCSessionManager()

    private override init() {
        super.init()
        activate()
    }

    private func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    func sendHRV(_ value: Double) {
        let session = WCSession.default

        guard session.activationState == .activated else { return }
        guard session.isReachable else { return }

        session.sendMessage(
            ["hrv": value],
            replyHandler: nil
        )
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}
    
    func sendHRVToiPhone(_ hrv: Double) {
        guard WCSession.default.isReachable else { return }

        WCSession.default.sendMessage(
            ["hrv": hrv],
            replyHandler: nil,
            errorHandler: nil
        )
    }
}

