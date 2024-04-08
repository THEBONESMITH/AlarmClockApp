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

    // New Timer properties to manage sound playback durations
    var wristwatchTimer: Timer?
    var bellTimer: Timer?

    init() {
        setupAudioPlayers()
    }
    
    deinit {
        // Invalidate timers when the instance is deinitialized to avoid memory leaks
        wristwatchTimer?.invalidate()
        bellTimer?.invalidate()
    }
    
    func turnOffAlarm() {
        print("Turning off alarm...")
        
        // Stop both audio players
        wristwatchPlayer?.stop()
        bellPlayer?.stop()
        
        // Invalidate and nullify the timers to prevent them from firing again
        wristwatchTimer?.invalidate()
        bellTimer?.invalidate()
        wristwatchTimer = nil
        bellTimer = nil

        // Update state to reflect that the alarm is no longer active
        isAlarmActive = false
        shouldShowMemoryGame = false
        alarmTime = nil
        
        print("Alarm turned off")
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
            // Initially start with the wristwatch sound
            startWristwatchSound()
        }
    
    func startWristwatchSound() {
            wristwatchPlayer?.play()
            
            // Invalidate existing bell timer if any
            bellTimer?.invalidate()
            
            // Schedule wristwatch sound to play for 30 seconds
            wristwatchTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
                self?.startBellSound()
            }
        }
    
    func startBellSound() {
            // Stop the wristwatch sound and start the bell sound
            wristwatchPlayer?.stop()
            bellPlayer?.play()
            
            // Invalidate existing wristwatch timer if any
            wristwatchTimer?.invalidate()
            
            // Schedule bell sound to play for 10 seconds
            bellTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { [weak self] _ in
                self?.startWristwatchSound()
            }
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
