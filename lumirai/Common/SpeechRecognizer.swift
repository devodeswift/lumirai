//
//  SpeechRecognizer.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation
import AVFoundation
import Combine
import Speech

class SpeechRecognizer: NSObject, ObservableObject {
    
    @Published var text: String = ""
    
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    override init() {
        super.init()
        recognizer.delegate = self
    }
    
    func startListening() {
        stopListening()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true)
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else { return }
        
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.text = result.bestTranscription.formattedString
                }
            }
            
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0)
        
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopListening() {
        audioEngine.stop()
        request?.endAudio()
        task?.cancel()
    }
}

extension SpeechRecognizer: SFSpeechRecognizerDelegate {}
