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
    @Published var textContinue: String = "Continue"
    @Published var textAnnualPrice: String = "€129/year"
    @Published var text7Days: String = "7 days free trial"
    @Published var textSubscribeYearly: String = "Subscribe Yearly"
    @Published var textMonthlyPrice: String = "€14.99/month"
    @Published var textTrial: String = "Start Free Trial"
    @Published var textDescription: String = "Unlimited session \n Apple Watch Companion \n Your emotional space"
    @Published var textCancel: String = "Cancel anytime · Privacy · Terms"
    
    
    
    
    override func start() {
        
    }
    
    func startBreathing() {
        inhale()
    }

    private func inhale() {
        withAnimation(.easeInOut(duration: 4.0)) {
            scale = 0.5
            coreOpacity = 0.75
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.exhale()
        }
    }

    private func exhale() {
        withAnimation(.easeInOut(duration: 6.0)) {
            scale = 1.0
            coreOpacity = 0.88
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.inhale()
        }
    }
}
