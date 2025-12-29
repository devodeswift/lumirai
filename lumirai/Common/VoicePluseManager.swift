//
//  VoicePluseManager.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation
import Combine
import AVFoundation

class VoicePulseManager: ObservableObject {
    private let engine = AVAudioEngine()
    
    @Published var amplitude: CGFloat = 0.0
    
    func start() {
        let inputNode = engine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            guard let channelData = buffer.floatChannelData?[0] else { return }
            
            let frameCount = Int(buffer.frameLength)
            let rms = sqrt((0..<frameCount).reduce(0.0) {
                $0 + Double(channelData[$1] * channelData[$1])
            } / Double(frameCount))
            
            let normalized = min(max(CGFloat(rms * 25), 0.05), 1.2)
            
            DispatchQueue.main.async {
                self.amplitude = normalized
            }
        }
        
        try? engine.start()
    }
    
    func stop() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        amplitude = 0.0
    }
}
