//
//  AlarmManager.swift
//  Alarm Clock
//
//  Created by . . on 05/04/2024.
//

import Foundation
import AVFoundation

class AlarmManager: ObservableObject {
    var alarmTime: Date?
    var timer: Timer?
    var wristwatchPlayer: AVAudioPlayer?
    var bellPlayer: AVAudioPlayer?
    var isPlayingWristwatchAlarm = true

    init() {
        setupAudioPlayers()
    }

    func setupAudioPlayers() {
        guard let wristwatchURL = Bundle.main.url(forResource: "Alarm Wristwatch", withExtension: "aif"),
              let bellURL = Bundle.main.url(forResource: "Bell Fire Alarm", withExtension: "aif") else {
            print("Audio files not found in app bundle")
            return
        }

        do {
            wristwatchPlayer = try AVAudioPlayer(contentsOf: wristwatchURL)
            bellPlayer = try AVAudioPlayer(contentsOf: bellURL)
            
            wristwatchPlayer?.numberOfLoops = -1 // Loop indefinitely
            bellPlayer?.numberOfLoops = 0 // Play once
        } catch {
            print("Could not load file: \(error)")
        }
    }

    func playSound() {
        if isPlayingWristwatchAlarm {
            wristwatchPlayer?.play()
            Timer.scheduledTimer(withTimeInterval: 300, repeats: false) { _ in
                self.switchToBellAlarm()
            }
        } else {
            switchToWristwatchAlarm()
        }
    }

    func switchToBellAlarm() {
        wristwatchPlayer?.stop()
        bellPlayer?.play()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { _ in
            self.switchToWristwatchAlarm()
        }
    }

    func switchToWristwatchAlarm() {
        bellPlayer?.stop()
        isPlayingWristwatchAlarm = true
        playSound()
    }

    func cancelAlarm() {
        wristwatchPlayer?.stop()
        bellPlayer?.stop()
        timer?.invalidate()
        timer = nil
        alarmTime = nil
    }
}


