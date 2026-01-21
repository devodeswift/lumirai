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
        setLoading(true)
        defer { setLoading(false) }
        let currentText = text
        let emotion = self.emotion
//        AppUserDefaults.shared.appendLastUserText(currentText)
        let lastText = AppUserDefaults.shared.lastUserTexts.map {$0.text}.joined(separator: "\",\"")
        AppLogger.shared.log("cek currentText => \(currentText)")
        AppLogger.shared.log("cek emotion => \(emotion)")
        AppLogger.shared.log("cek lasttext => \(lastText)")
        
        
        let request = RequestGeminiModel(
            system_instruction: SystemInstruction(
                parts: [
                    TextPart(text: "You are an empathetic health assistant. Analyze the user's emotions. The user will input their condition in JSON format (without markdown) using the following schema: \"{\"current_text\": string(user's current input in English), \"detect_emotion_hrv\": string (keywords: calm, sadness, anxiety, unknown), \"last_text\": array string(user's inputs from the last 48 hours in English)}\" Provide responses ONLY in JSON format (without markdown) with the following schema: {\"emotion\": string (calm, sadness, anxiety), \"echo\": string (a soothing emotional validation sentence in English), \"action\": string (action keywords such as: breathe, walk, call, journal), \"duration_sec\": integer (recommended duration in seconds), \"button\": string (short button label in English) }")
                ]
            ),
            contents: [
                Content(
                    parts: [
                        TextPart(
                            text: "{\"current_text\": \"\(currentText)\", \"detect_emotion_hrv\": \"\(emotion)\", \"last_text\":[\"\(lastText)]}"
                        )
                    ]
                )
            ]
        )
        
        Task {
            do {
                let response = try await apiService.generateContent(dataParam: request)
//                AppLogger.shared.log("cek article response => \(articleResponse.per_page)")
//                let json = JSON(TestDummyData.shared.getDummyJSON(fileName: "action-breath-dummy"))
//                let response = GeminiResponseModel(json)

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
                if geminiAction != nil {
                    AppUserDefaults.shared.appendLastUserText(currentText)
                }
            } catch {
                AppLogger.shared.log("Failed to fetch response: \(error)")
                handleError()
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
