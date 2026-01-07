//
//  ExpressionViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation
import Combine
import WatchConnectivity


class ExpressionViewModel: BaseViewModel {
    
    
    @Published var textTitle: String = "LUMIRAi"
    @Published var textPlaceholder: String = "When you’re ready, I’m listening."
    @Published var pulseManager = VoicePulseManager()
    @Published var haloPulse: CGFloat = 1.0
    @Published var speech = SpeechRecognizer()
    private var hrvBaseline: Double?
    private let wcSession = WCSessionManager.shared
    @Published var hrv: Double?
    
    override func start() {
        wcSession.$latestHRV
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] value in
                        guard let value else { return }
                        self?.hrv = value
                        self?.updateHaloPulse(from: value)
                    }
                    .store(in: &cancellables)
    }
    
    private func updateHaloPulse(from hrv: Double) {
            // contoh mapping
            //haloPulse = min(max(CGFloat(hrv / 100), 0.8), 1.3)
        AppLogger.shared.log("cek hrv expression => \(hrv)")
        }

    
}
