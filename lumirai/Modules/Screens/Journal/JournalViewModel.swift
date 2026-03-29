//
//  JournalViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/03/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftyJSON

class JournalViewModel: BaseViewModel {
    @Published var scale: Double = 1.0
    @Published var coreOpacity: Double = 0.85
    @Published var duration: Double = 0.0
    @Published var textTitle: String = "LUMIRAi"
    @Published var textPlaceholder: String = "Enter text here"
    @Published var textJournal: String = ""
    @Published var isShowTextJournal: Bool = false
    
    
    var timeCountDown : Double = 0
    private var timer: Timer?
    var onFinished: (() -> Void)?
    
    let breathing = BreathingEngine()
    
    override init(){
        super.init()
        breathing.onUpdate = { [weak self] scale, coreOpacity, duration in
            DispatchQueue.main.async {
                self?.scale = scale
                self?.coreOpacity = coreOpacity
                self?.duration = duration
            }
        }
        self.startTimer(duration: 190)
        self.getTextRandomJournal()
    }
    
    func startBreathing(){
        breathing.inhale()
    }
    
    func startTimer(duration: Double) {
        stopTimer()
        timeCountDown = 0
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.timeCountDown += 1
            let textShowDuration = duration - 10
            if self.timeCountDown == textShowDuration {
                isShowTextJournal = true
            }
            
            if self.timeCountDown >= duration {
                self.stopTimer()
                self.onFinished?()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func getTextRandomJournal(){
        let templateJournalFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-journal"))
        let dataTemplateJournal = templatesModel(templateJournalFile)
        if let resultJournal = dataTemplateJournal.dataTemplates.randomElement() {
            textJournal = resultJournal
        }
    }
    
}
