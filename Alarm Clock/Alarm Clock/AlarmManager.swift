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
    var volumeAdjustTimer: Timer?
    var initialVolume: Float = 0.0 // Holds the initial volume

    init() {
        setupAudioPlayers()
    }
    
    deinit {
        // Invalidate timers when the instance is deinitialized to avoid memory leaks
        wristwatchTimer?.invalidate()
        bellTimer?.invalidate()
    }
    
    func graduallyIncreaseSystemVolume(to targetVolume: Int = 100, over duration: TimeInterval = 10) {
        // Calculate the volume increment
        let increments = 10 // Adjust the number of increments as needed
        let incrementVolume = targetVolume / increments
        let timeInterval = duration / Double(increments)
        
        for step in 1...increments {
            DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                let volume = incrementVolume * step
                let script = """
                    osascript -e "set volume output volume \(volume)"
                """
                // Execute the AppleScript command
                self.executeCommand(script)
            }
        }
    }

    func executeCommand(_ command: String) {
        let process = Process()
        let pipe = Pipe()
        
        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-c", command]
        process.launchPath = "/bin/zsh"
        process.launch()
        
        process.waitUntilExit() // You might want to handle this asynchronously depending on your app's needs
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
            // Step 1: Indicate the alarm is active and the memory game should be shown
            self.isAlarmActive = true
            self.shouldShowMemoryGame = true
            
            // Step 2: Start playing the alarm sound
            self.playSound()
            
            // Gradually increase system volume starting shortly after the sound begins
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.graduallyIncreaseSystemVolume(to: 100, over: 10)
            }
            
            // The Memory Game's presentation is tied to the `shouldShowMemoryGame` property.
            // Assuming your SwiftUI views observe this property, changing its value to `true`
            // should automatically update the UI to present the game.
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
            // Ensure the bell sound is stopped before starting the wristwatch sound
            bellPlayer?.stop()
            bellTimer?.invalidate()

            wristwatchPlayer?.play()
            
            // Schedule wristwatch sound to play for 30 seconds
            wristwatchTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
                self?.startBellSound()
            }
        }
        
        func startBellSound() {
            // Ensure the wristwatch sound is stopped before starting the bell sound
            wristwatchPlayer?.stop()
            wristwatchTimer?.invalidate()

            bellPlayer?.play()
            
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
