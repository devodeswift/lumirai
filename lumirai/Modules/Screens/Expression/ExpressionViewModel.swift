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
    @Published var scale: Double = 1.0
    @Published var coreOpacity: Double = 0.85
    @Published var duration: Double = 0.0
    private var emotion: EmotionState = .unknown
    private var hrvBaseline: Double?
    
    let apiService = APIService()
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
    }
    
    func startBreathing(){
        breathing.inhale()
    }
    
    func sendTextEngine(text: String) {
        let sessionCount = AppUserDefaults.shared.incrementWeeklySession()
        
        let isLongText = isMoreThan12Words(text)
        let isFrequentUser = sessionCount > 3
        let isLateNight = isAfter10PM()
        
        if isLongText || isFrequentUser || isLateNight {
            generateText(text: text)
        } else {
            getResponse(text: text)
        }
    }
    
    func getResponse(text: String) {
        getResponse = true
        AppLogger.shared.log("getResponse: \(textResponse)")
        AppSettings.shared.updateUsageCountIfNeeded()
        var duration = 60
            
        
        let tempalteMemoryCallbackFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-memory-callback"))
        let dataTemplateMemoryCallback = templatesMemoryCallbackModel(tempalteMemoryCallbackFile)
        let latesTextResultCountPerday = Set(
            AppUserDefaults.shared
                .getLastUserTexts(for: KeysAppUserDefaults.lastTextResultCountPerDay)
                .map { $0.text }
        )
        AppLogger.shared.log("lastTextResultCountPerday: \(latesTextResultCountPerday)")
        if AppUserDefaults.shared.usageCountPerDay <= 30 && AppUserDefaults.shared.usageCountPerDay > 0 {
            let availableTextResultCountPerday = dataTemplateMemoryCallback.dataTemplates30Days
                .filter { !latesTextResultCountPerday.contains($0) }
            
            if let result30Days = availableTextResultCountPerday.randomElement() {
                textResponse = result30Days
                AppUserDefaults.shared.appendLastUserText(result30Days, for: KeysAppUserDefaults.lastTextResultCountPerDay)
            }
        } else if AppUserDefaults.shared.usageCountPerDay > 30 && AppUserDefaults.shared.usageCountPerDay <= 90 {
            let availableTextResultCountPerday = dataTemplateMemoryCallback.dataTemplates90Days
                .filter { !latesTextResultCountPerday.contains($0) }
            if let result90Days = availableTextResultCountPerday.randomElement() {
                textResponse = result90Days
                AppUserDefaults.shared.appendLastUserText(result90Days, for: KeysAppUserDefaults.lastTextResultCountPerDay)
            }
        } else if AppUserDefaults.shared.usageCountPerDay > 90 {
            let availableTextResultCountPerday = dataTemplateMemoryCallback.dataTemplates120Days
                .filter { !latesTextResultCountPerday.contains($0) }
            if let result120Days = availableTextResultCountPerday.randomElement() {
                textResponse = result120Days
                AppUserDefaults.shared.appendLastUserText(result120Days, for: KeysAppUserDefaults.lastTextResultCountPerDay)
                
            }
        }
        
        let hour = Calendar.current.component(.hour, from: Date())
        let latesTextResultHour = Set(
            AppUserDefaults.shared
                .getLastUserTexts(for: KeysAppUserDefaults.lastTextResultCountHour)
                .map { $0.text }
        )
        switch hour {
        case 5..<12:
            let templateMorningFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-morning"))
            let dataTemplateMorning = templatesModel(templateMorningFile)
            let availableTextResultMorningHours = dataTemplateMorning.dataTemplates.filter { !latesTextResultHour.contains($0) }
            if let resultMorning = availableTextResultMorningHours.randomElement() {
                textResponse += "|" + resultMorning
                AppUserDefaults.shared.appendLastUserText(resultMorning, for: KeysAppUserDefaults.lastTextResultCountHour)
            }
            
        case 12..<17:
            let templateAfternoonFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-afternoon"))
            let dataTemplateAfternoon = templatesModel(templateAfternoonFile)
            let availableTextResultAfternoonHours = dataTemplateAfternoon.dataTemplates.filter { !latesTextResultHour.contains($0) }
            if let resultAfternoon = availableTextResultAfternoonHours.randomElement() {
                textResponse += "|" + resultAfternoon
                AppUserDefaults.shared.appendLastUserText(resultAfternoon, for: KeysAppUserDefaults.lastTextResultCountHour)
            }
            
        case 17..<21:
            let templateEveningFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-evening"))
            let dataTemplateEvening = templatesModel(templateEveningFile)
            let availableTextResultEveningHours = dataTemplateEvening.dataTemplates.filter { !latesTextResultHour.contains($0) }
            if let resultEvening = availableTextResultEveningHours.randomElement() {
                textResponse += "|" + resultEvening
                AppUserDefaults.shared.appendLastUserText(resultEvening, for: KeysAppUserDefaults.lastTextResultCountHour)
            }
        default:
            let templateNightFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-night"))
            let dataTemplateNight = templatesModel(templateNightFile)
            let availableTextResultNightHours = dataTemplateNight.dataTemplates.filter { !latesTextResultHour.contains($0) }
            if let resultNight = availableTextResultNightHours.randomElement() {
                textResponse += "|" + resultNight
                AppUserDefaults.shared.appendLastUserText(resultNight, for: KeysAppUserDefaults.lastTextResultCountHour)
            }
        }
        
        let emotionModeFromText = self.detectEmotion(text: text)
//        let emotionFromWatch = self.detectEmotionFromWatch()
        let latesTextResultEmotion = Set(
            AppUserDefaults.shared
                .getLastUserTexts(for: KeysAppUserDefaults.lastTextResultEmotion)
                .map { $0.text }
        )
        switch emotionModeFromText {
        case .stress:
            if isConnectedWatch() || AppUserDefaults.shared.lastEmotionState == "stress" {
                textResponse = "Stay with me."
                duration = 12
            } else {
                let templateStressFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-stress"))
                let dataTemplateStress = templatesModel(templateStressFile)
                let availableTextResultStressEmotion = dataTemplateStress.dataTemplates.filter { !latesTextResultEmotion.contains($0) }
                if let resultStress = availableTextResultStressEmotion.randomElement() {
                    textResponse += "|" + resultStress
                    AppUserDefaults.shared.textResultEmotion = resultStress
                    AppUserDefaults.shared.appendLastUserText(resultStress, for: KeysAppUserDefaults.lastTextResultEmotion)
                }
            }
            AppUserDefaults.shared.lastEmotionState = "stress"
            
        case .fatigue:
            let templateFatigueFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-fatigue"))
            let dataTemplateFatigue = templatesModel(templateFatigueFile)
            let availableTextResultFatigueEmotion = dataTemplateFatigue.dataTemplates.filter { !latesTextResultEmotion.contains($0) }
            if let resultFatigue = availableTextResultFatigueEmotion.randomElement() {
                textResponse += "|" + resultFatigue
                AppUserDefaults.shared.appendLastUserText(resultFatigue, for: KeysAppUserDefaults.lastTextResultEmotion)
            }
            AppUserDefaults.shared.lastEmotionState = "fatigue"
        case .existential:
            let templateExistentialFile = JSON(TestDummyData.shared.getDummyJSON(fileName: "template-existential"))
            let dataTemplateExistential = templatesModel(templateExistentialFile)
            let availableTextResultExistentialEmotion = dataTemplateExistential.dataTemplates.filter { !latesTextResultEmotion.contains($0) }
            if let resultExistential = availableTextResultExistentialEmotion.randomElement() {
                textResponse += "|" + resultExistential
                AppUserDefaults.shared.appendLastUserText(resultExistential, for: KeysAppUserDefaults.lastTextResultEmotion)
            }
            AppUserDefaults.shared.lastEmotionState = "existential"
        case .none:
            AppLogger.shared.log("no emotion")
        }
        
        AppLogger.shared.log("textResponse => \(textResponse)")
        
        var dataGeminiAction = GeminiActionModel()
        dataGeminiAction.action = "test"
        dataGeminiAction.echo = textResponse
        dataGeminiAction.durationSec = duration
        geminiAction = dataGeminiAction
    
    }

    func generateText(text: String) {
        getResponse = true
        setLoading(true)
        defer { setLoading(false) }
//        let currentText = text
//        let emotion = self.emotion
////        AppUserDefaults.shared.appendLastUserText(currentText)
//        let lastText = AppUserDefaults.shared.lastUserTexts.map {$0.text}.joined(separator: "\",\"")
//        AppLogger.shared.log("cek currentText => \(currentText)")
//        AppLogger.shared.log("cek emotion => \(emotion)")
//        AppLogger.shared.log("cek lasttext => \(lastText)")
        
        
        let request = RequestGeminiModel(
            system_instruction: SystemInstruction(
                parts: [
                    TextPart(text: "You are LUMIRAi, an empathetic health assistant with a calm, somatic presence.\n\nYou analyze the user's emotional state quietly and gently, without over-explaining.\n\nThe user input will be a plain text message describing their current feelings.\n\nYour task:\n- Detect the user's dominant emotion from the text\n- Validate it with a short, soothing sentence\n- Suggest ONE simple, gentle action\n\nTone rules (Lumirai style):\n- Calm, soft, grounding\n- No questions\n- No explanations\n- No motivational language\n- No over-guidance\n- Keep it minimal and natural\n\nOutput rules:\n- emotion must be one of: calm, sadness, anxiety\n- echo must be a single short sentence (max 12–15 words)\n- echo must feel like quiet validation, not advice\n- action must be one of: breathe, walk, call, journal\n- duration_sec must be exactly 180\n- button must be very short (1–3 words)\n\nStrict output:\nReturn ONLY raw JSON.\nDo NOT wrap the response in markdown.\nDo NOT use ```json or ```.\nDo NOT add any extra text.\nOutput must start with { and end with }.\n\n{\"emotion\": string, \"echo\": string, \"action\": string, \"duration_sec\": 60, \"button\": string}")
                ]
            ),
            contents: [
                Content(
                    parts: [
                        TextPart(
                            text: "\(text)"
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
        let normalized = text.lowercased()
        let words = Set(
            normalized.components(
                separatedBy: CharacterSet.alphanumerics.inverted
            )
        )

        for keyword in keywords {
            if keyword.contains(" ") {
                if normalized.contains(keyword) {
                    return true
                }
            } else {
                if words.contains(keyword) {
                    return true
                }
            }
        }

        return false
    }
    
    func detectEmotion(text: String) -> EmotionMode {
        
        if containsKeyword(in: text, keywords: EmotionKeywords.stress) { return .stress}
        if containsKeyword(in: text, keywords: EmotionKeywords.fatigue) { return .fatigue}
        if containsKeyword(in: text, keywords: EmotionKeywords.existential) { return .existential }
        
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
    
    func isConnectedWatch() -> Bool {
        return WCSession.default.isPaired
    }
    
    func isMoreThan12Words(_ text: String) -> Bool {
        let words = text
            .components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        return words.count > 12
    }
    
    func isAfter10PM() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 22
    }
    
}
