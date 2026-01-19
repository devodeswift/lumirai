//
//  CalmViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation
import Combine
import SwiftUI

class CalmViewModel: BaseViewModel {
    @Published var progress: CGFloat = 0.0
    @Published var timeElapsed: Double = 0
    @Published var action: MicroActionModel = .unknown
    @Published var journalText : String = ""
    @FocusState private var isFocused : Bool
    
    var resultAction: GeminiActionModel
    private var timer: Timer?
    
    
    init(resultAction: GeminiActionModel){
        self.resultAction = resultAction
        self.action = MicroActionModel(rawValue: resultAction.action) ?? .unknown
        super.init()
    }
    
    
    func startTimer() {
            timer?.invalidate()
            timeElapsed = 0
            progress = 0

            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                self?.updateTimer()
            }
        }

        func stopTimer() {
            timer?.invalidate()
            timer = nil
        }

        func updateTimer() {
            let actionDuration: Double = Double(resultAction.durationSec)
            guard timeElapsed < actionDuration else {
                stopTimer()
                return
            }

            timeElapsed += 0.05

            withAnimation(.linear(duration: 0.05)) {
                progress = CGFloat(timeElapsed / actionDuration)
            }
        }
    
    
}
