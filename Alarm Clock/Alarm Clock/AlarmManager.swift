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

    func setAlarm(hour: Int, minute: Int) {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)

        if hour == currentHour && minute == currentMinute {
            // If the times match, trigger the alarm immediately.
            DispatchQueue.main.async {
                // Assuming playSound() triggers the puzzle view or alarm sound.
                self.playSound()
            }
        } else {
            // Set the alarm for a future time.
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = hour
            components.minute = minute
            alarmTime = calendar.date(from: components)
            
            // Schedule a timer or background task to check the alarm time.
            // Your existing scheduling logic here.
        }
    }

    func checkAlarm() {
        guard let alarmTime = alarmTime else { return }

        let now = Date()
        if Calendar.current.isDate(now, equalTo: alarmTime, toGranularity: .minute) {
            // Alarm time reached, play sound
            playSound()
        }
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
        print("Playing wristwatch sound")
        wristwatchPlayer?.play()
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
