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
    private var hrvBaseline: Double?
    private let wcSession = WCSessionManager.shared
    
    let apiService = APIService()
    
    override func start() {
        wcSession.$latestHRV
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let value else { return }
                self?.hrv = value
                self?.updateHaloPulse(from: value)
            }
            .store(in: &cancellables)
    }
    
    private func updateHaloPulse(from hrv: Double) {
        AppLogger.shared.log("cek hrv expression => \(hrv)")
    }

    func generateText() {
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
}
