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
    @Published var textDescription: String = "Unlimited session \n Apple Watch Companion \n Your emotional space \nYour space continues."
    @Published var textCancel: String = "Cancel anytime · Privacy · Terms"
    
    let breathing = BreathingEngine()
    
    
    override func start() {
        
    }
    
    override init(){
        super.init()
        breathing.onUpdate = { [weak self] scale, coreOpacity, duration in
            DispatchQueue.main.async {
                self?.scale = scale
                self?.coreOpacity = coreOpacity
                self?.duration = duration
            }
        }
    }
    
    func startBreathing() {
        breathing.inhale()
    }
    
}
