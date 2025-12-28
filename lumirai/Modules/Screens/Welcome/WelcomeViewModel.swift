//
//  WelcomeViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import Combine

class WelcomeViewModel: BaseViewModel {
    @Published var audio = AudioManager()
    @Published var audioBreath = AudioManager()
    @Published var letters: [String] = ["L", "U", "M", "I", "R", "A", "i"]
    @Published var txtTittleTop: String = "Silence that holds you."
    @Published var txtTittleBot: String = "Luxury is no longer gold. It's inner peace."
    @Published var textButton: String = "enter the calm"
    
    override func start() {
        
    }
    
}
