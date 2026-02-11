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
    @Published var textResponse: String = ""
    @Published var getResponse: Bool = false
    private var emotion: EmotionState = .unknown
    private var hrvBaseline: Double?
    
    let apiService = APIService()
    
    func getResponse(text: String) {
        getResponse = true
        
        AppInfo.shared.updateUsageCountIfNeeded()
        let tempalteMemoryCallbackFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-memory-callback"))
        let dataTemplateMemoryCallback = templatesMemoryCallbackModel(tempalteMemoryCallbackFile)
        if AppUserDefaults.shared.usageCountPerDay <= 30 && AppUserDefaults.shared.usageCountPerDay > 0 {
            if let result30Days = dataTemplateMemoryCallback.dataTemplates30Days.randomElement() {
                textResponse = result30Days
            }
        } else if AppUserDefaults.shared.usageCountPerDay > 30 && AppUserDefaults.shared.usageCountPerDay <= 90 {
            if let result90Days = dataTemplateMemoryCallback.dataTemplates90Days.randomElement() {
                textResponse = result90Days
            }
        } else if AppUserDefaults.shared.usageCountPerDay > 90 {
            if let result120Days = dataTemplateMemoryCallback.dataTemplates120Days.randomElement() {
                textResponse = result120Days
            }
        }
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            let templateMorningFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-morning"))
            let dataTemplateMorning = templatesModel(templateMorningFile)
            if let resultMorning = dataTemplateMorning.dataTemplates.randomElement() {
                textResponse += "|" + resultMorning
            }
            
        case 12..<17:
            let templateAfternoonFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-afternoon"))
            let dataTemplateAfternoon = templatesModel(templateAfternoonFile)
            if let resultAfternoon = dataTemplateAfternoon.dataTemplates.randomElement() {
                textResponse += "|" + resultAfternoon
            }
            
        case 17..<21:
            let templateEveningFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-evening"))
            let dataTemplateEvening = templatesModel(templateEveningFile)
            if let resultEvening = dataTemplateEvening.dataTemplates.randomElement() {
                textResponse += "|" + resultEvening
            }
        default:
            let templateNightFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-night"))
            let dataTemplateNight = templatesModel(templateNightFile)
            if let resultNight = dataTemplateNight.dataTemplates.randomElement() {
                textResponse += "|" + resultNight
            }
        }
        
        let emotionModeFromText = self.detectEmotion(text: text)
        let emotionFromWatch = self.detectEmotionFromWatch()
        var resultEmotion : EmotionMode = .none
        
        if emotionModeFromText != emotionFromWatch {
            resultEmotion = emotionModeFromText
        } else {
            resultEmotion = emotionFromWatch
        }
        
        switch resultEmotion {
        case .stress:
            let templateStressFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-stress"))
            let dataTemplateStress = templatesModel(templateStressFile)
            if let resultStress = dataTemplateStress.dataTemplates.randomElement() {
                textResponse += "|" + resultStress
            }
        case .fatigue:
            let templateFatigueFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-fatigue"))
            let dataTemplateFatigue = templatesModel(templateFatigueFile)
            if let resultFatigue = dataTemplateFatigue.dataTemplates.randomElement() {
                textResponse += "|" + resultFatigue
            }
        case .existential:
            let templateExistentialFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-existential"))
            let dataTemplateExistential = templatesModel(templateExistentialFile)
            if let resultExistential = dataTemplateExistential.dataTemplates.randomElement() {
                textResponse += "|" + resultExistential
            }
        case .none:
            AppLogger.shared.log("no emotion")
        }
        
        
        
        var dataGeminiAction = GeminiActionModel()
        dataGeminiAction.action = "test"
        dataGeminiAction.echo = textResponse
        dataGeminiAction.durationSec = 60
        geminiAction = dataGeminiAction
    
    }

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
    
    func containsKeyword(in text: String, keywords: [String]) -> Bool {
        let lower = text.lowercased()
        return keywords.contains { lower.contains($0) }
    }
    
    func detectEmotion(text: String) -> EmotionMode {
        let stressKeywords = ["stress","stressed","anxious","anxiety","panic","worried","worry","overwhelmed","tense","nervous","pressure"]
        let fatigueKeywords = ["tired","exhausted","sleep","sleepy","drained","weary","rest","heavy","fatigue"]
        let existentialKeywords = ["why","meaning","purpose","point","lost","don't know","unclear","confused","empty"]
        
        if containsKeyword(in: text, keywords: stressKeywords) { return .stress}
        if containsKeyword(in: text, keywords: fatigueKeywords) { return .fatigue}
        if containsKeyword(in: text, keywords: existentialKeywords) { return .existential }
        
        return .none
    }
    
    func detectEmotionFromWatch() -> EmotionMode {
        let baselineHR = 70.0
        let baselineHRV = 30.0
        
        let highHR = AppUserDefaults.shared.hearRate > baselineHR + 10      // > 80
        let lowHR = AppUserDefaults.shared.hearRate < baselineHR - 8        // < 62
        let lowHRV = AppUserDefaults.shared.hrv < baselineHRV - 10    // < 20
        
        // STRESS
        if highHR && lowHRV {
            return .stress
        }
        
        // FATIGUE
        if lowHR && lowHRV {
            return .fatigue
        }
        return .none
    }
    
}
