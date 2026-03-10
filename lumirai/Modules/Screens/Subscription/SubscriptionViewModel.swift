//
//  SubscriptionViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import Combine
import SwiftUI

class SubscriptionViewModel: BaseViewModel {
    
    @Published var textTitle: String = "LUMIRAi"
    @Published var scale: CGFloat = 1.0
    @Published var coreOpacity: Double = 0.85
    @Published var duration: Double = 0.0
    @Published var textContinue: String = "Continue"
    @Published var textAnnualPrice: String = "€129/year"
    @Published var text7Days: String = "7 days free trial"
    @Published var textSubscribeYearly: String = "Subscribe Yearly"
    @Published var textMonthlyPrice: String = "€14.99/month"
    @Published var textTrial: String = "Start Free Trial"
    @Published var textDescription: String = "Unlimited session \n Apple Watch Companion \n Your emotional space"
    @Published var textCancel: String = "Cancel anytime · Privacy · Terms"
    
    let breathing = BreathingEngine()
    
    
    override func start() {
        
    }
    
    func startBreathing() {
        inhale()
    }
    
    private func inhale() {
        duration = breathing.inhaleDuration()

        scale = AppSettings.shared.jitter(0.96, percent: 0.06)
        coreOpacity = AppSettings.shared.jitter(0.76, percent: 0.05)

        AppLogger.shared.log("cek Scale inhale: \(scale)")
        AppLogger.shared.log("cek coreOpacity inhale: \(coreOpacity)")

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.exhale()
        }
    }
    
    private func exhale() {
        duration = breathing.exhaleDuration()
        
        scale = AppSettings.shared.jitter(1.15, percent: 0.04)
        coreOpacity = AppSettings.shared.jitter(0.88, percent: 0.04)
        
        AppLogger.shared.log("cek Scale exhale: \(scale)")
        AppLogger.shared.log("cek coreOpacity exhale: \(coreOpacity)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.inhale()
        }
    }

}
