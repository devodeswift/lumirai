//
//  AudioManager.swift
//  lumirai
//
//  Created by dana nur fiqi on 26/11/25.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    var player: AVAudioPlayer?
    var fadeTimer: Timer?

    func playWithFadeIn(url: URL, duration: TimeInterval = 2.0) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0
            player?.numberOfLoops = -1
            player?.play()

            let fadeStep = 0.01
            let stepTime = duration / Double(1.0 / fadeStep)

            fadeTimer?.invalidate()
            fadeTimer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { _ in
                if let player = self.player {
                    if player.volume < 1.0 {
                        player.volume += Float(fadeStep)
                    } else {
                        self.fadeTimer?.invalidate()
                    }
                }
            }

        } catch {
            AppLogger.shared.log("Error playing audio: \(error)")
        }
    }
    
    func stopWithFadeOut(duration: TimeInterval = 0.5) {
        let fadeStep: Float = 0.02
        let stepTime = duration / Double(1.0 / fadeStep)

        fadeTimer?.invalidate()
        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { _ in
            guard let player = self.player else { return }

            if player.volume > 0.0 {
                player.volume -= fadeStep
            } else {
                player.stop()
                self.fadeTimer?.invalidate()
            }
        }
    }
}
