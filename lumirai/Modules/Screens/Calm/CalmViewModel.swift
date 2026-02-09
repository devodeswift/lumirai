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
    var onFinished: (() -> Void)?
    
    init(resultAction: GeminiActionModel){
        self.resultAction = resultAction
        self.action = MicroActionModel(rawValue: resultAction.action) ?? .unknown
        super.init()
        self.startTimer(duration: Double(resultAction.durationSec))
    }
    
    func startTimer(duration: Double = 8) {
        stopTimer()
        timeElapsed = 0
        progress = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.timeElapsed += 0.05
            self.progress = min(self.timeElapsed / duration, 1)
            
            if self.timeElapsed >= duration {
                self.stopTimer()
                self.onFinished?()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
