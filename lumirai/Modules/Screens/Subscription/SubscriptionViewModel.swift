//
//  SubscriptionViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import Combine

class SubscriptionViewModel: BaseViewModel {
    
    @Published var textDescSubscription: String = "Chose Your Plan"
    @Published var textLightPlan: String = "Light"
    @Published var textOnePlan: String = "One"
    @Published var textFounderPlan: String = "Founder"
    @Published var textPriceLightPlan: String = "€69.99/year"
    @Published var textPriceOnePlan: String = "€99.99/year"
    @Published var textPriceFounderPlan: String = "€139–299 lifetime"
    @Published var textBtnContinue: String = "Continue"
    
    override func start() {
        
    }
}
