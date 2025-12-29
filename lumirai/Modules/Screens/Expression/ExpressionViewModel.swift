//
//  ExpressionViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation
import Combine

class ExpressionViewModel: BaseViewModel {
    @Published var textTitle: String = "LUMIRAi"
    @Published var textPlaceholder: String = "When you’re ready, I’m listening."
    @Published var pulseManager = VoicePulseManager()
    @Published var haloPulse: CGFloat = 1.0
    @Published var speech = SpeechRecognizer()
    
}
