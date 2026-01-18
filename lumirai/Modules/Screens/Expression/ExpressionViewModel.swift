//
//  ExpressionViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation
import Combine
import WatchConnectivity
import Alamofire
import SwiftyJSON


class ExpressionViewModel: BaseViewModel {
    
    @Published var textTitle: String = "LUMIRAi"
    @Published var textPlaceholder: String = "When you’re ready, I’m listening."
    @Published var pulseManager = VoicePulseManager()
    @Published var haloPulse: CGFloat = 1.0
    @Published var speech = SpeechRecognizer()
    @Published var hrv: Double?
    @Published var geminiAction: GeminiActionModel?
    private var emotion: EmotionState = .unknown
    private var hrvBaseline: Double?
    
    let apiService = APIService()
    

    func generateText(text: String) {
        let currentText = text
        let emotion = self.emotion
        let lastText = AppUserDefaults.shared.lastUserTexts
        AppLogger.shared.log("cek currentText => \(currentText)")
        AppLogger.shared.log("cek emotion => \(emotion)")
        AppLogger.shared.log("cek lasttext => \(lastText)")
        
        Task {
            do {
//                let articleResponse = try await apiService.getData()
//                AppLogger.shared.log("cek article response => \(articleResponse.per_page)")
                let json = JSON(TestDummyData.shared.getDummyJSON(fileName: "action-breath-dummy"))
                let response = GeminiResponseModel(json)

                guard
                    let candidate = response.candidates.first,
                    let content = candidate.content,
                    let part = content.parts.first,
                    let action = part.action
                else {
                    return
                }
                let dataResultAction = action
                geminiAction = dataResultAction
                if let dataGeminiAction = geminiAction {
                    AppLogger.shared.log("cek dataGeminiAction response action=> \(dataGeminiAction.echo)")
                }
                AppLogger.shared.log("cek gemini response part => \(part.text)")
            } catch {
                AppLogger.shared.log("Failed to fetch articles: \(error)")
            }
        }
    }
    
    func checkEmotionFromWatch() {
        let hrv = AppUserDefaults.shared.hrv
        let heartRate = AppUserDefaults.shared.hearRate
        let breathingRate = AppUserDefaults.shared.breathRate
        
        emotion = EmotionEngine.detectEmotion(hrv: hrv, heartRate: heartRate, breathingRate: breathingRate)
        AppLogger.shared.log("hrv : \(hrv)")
        AppLogger.shared.log("heartRate : \(heartRate)")
        AppLogger.shared.log("breathingRate : \(breathingRate)")
        AppLogger.shared.log("emotion : \(emotion)")
    }
    
}
