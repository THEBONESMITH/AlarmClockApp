//
//  AlarmManager.swift
//  Alarm Clock
//
//  Created by . . on 05/04/2024.
//

import Foundation
import AVFoundation

class AlarmManager: ObservableObject {
    @Published var isAlarmActive: Bool = false
    @Published var shouldShowMemoryGame: Bool = false
    var alarmTime: Date?
    var wristwatchPlayer: AVAudioPlayer?
    var bellPlayer: AVAudioPlayer?
    var isPlayingWristwatchAlarm = true
    
    init() {
        setupAudioPlayers()
    }
    
    func turnOffAlarm() {
            isAlarmActive = false
            // Additional logic to actually stop the alarm sound if needed
        }
    
    func setAlarm(hour: Int, minute: Int) {
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute
        components.second = 0 // Ensure the alarm triggers at the start of the minute
        
        guard let alarmTime = calendar.date(from: components) else { return }
        
        self.alarmTime = alarmTime
        
        // Compare the alarmTime with the current time
        if alarmTime <= now {
            // If the alarmTime is now or in the past, trigger the alarm immediately
            triggerAlarm()
        } else {
            // Schedule the alarm for a future time
            let timeInterval = alarmTime.timeIntervalSinceNow
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
                self?.triggerAlarm()
            }
        }
    }

    func triggerAlarm() {
        DispatchQueue.main.async {
            print("Triggering alarm and showing memory game.")
            self.playSound()
            self.shouldShowMemoryGame = true
            self.isAlarmActive = true
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
            bellPlayer?.numberOfLoops = -1 // For consistent behavior, consider looping the bell sound as well
        } catch {
            print("Could not load file: \(error)")
        }
    }

    func playSound() {
        if isPlayingWristwatchAlarm {
            wristwatchPlayer?.play()
        } else {
            bellPlayer?.play()
        }
        print("Playing alarm sound")
    }

    func switchToBellAlarm() {
        wristwatchPlayer?.stop()
        bellPlayer?.play()
        isPlayingWristwatchAlarm = false
    }

    func switchToWristwatchAlarm() {
        bellPlayer?.stop()
        wristwatchPlayer?.play()
        isPlayingWristwatchAlarm = true
    }

    func cancelAlarm() {
        wristwatchPlayer?.stop()
        bellPlayer?.stop()
        isAlarmActive = false
        shouldShowMemoryGame = false
        // Resetting alarmTime to nil to indicate no active alarm
        alarmTime = nil
    }
}
