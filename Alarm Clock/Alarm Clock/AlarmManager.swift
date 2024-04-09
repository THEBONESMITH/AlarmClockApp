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
    var volumeCheckTimer: Timer?
    let targetVolume: Int = 100 // Target volume level
        let duration: TimeInterval = 10 // Duration over which to increase volume initially
        let checkInterval: TimeInterval = 2 // Interval to check and adjust volume if needed

    init() {
        setupAudioPlayers()
    }
    
    deinit {
        // Invalidate timers when the instance is deinitialized to avoid memory leaks
        wristwatchTimer?.invalidate()
        bellTimer?.invalidate()
    }
    
    func stopEnsuringVolume() {
        // Invalidate the timer when the alarm is turned off or game ends
        volumeCheckTimer?.invalidate()
    }
    
    func ensureMaximumVolume() {
        // Interval for how often to enforce maximum volume
        let enforcementInterval: TimeInterval = 2 // seconds

        // Cancel any existing timer to avoid multiple timers running simultaneously
        volumeCheckTimer?.invalidate()

        // Start a new timer to continuously enforce maximum volume
        volumeCheckTimer = Timer.scheduledTimer(withTimeInterval: enforcementInterval, repeats: true) { _ in
            // Command to set volume to its maximum
            let script = "osascript -e \"set volume output volume 100\""
            self.executeCommand(script)
        }
    }
    
    func continuouslyIncreaseVolume() {
        let targetVolume: Int = 100 // Maximum system volume level
        let initialStepVolume: Int = 30 // Starting increase from this volume if lower
        let increments = 7 // Divide the path to 100% into steps for smoother transition
        let timePerStep: TimeInterval = 2 // Time interval in seconds for each volume step increase

        // Initially ensure volume is at least at the starting point
        executeCommand("osascript -e \"set volume output volume \(initialStepVolume)\"")
        
        // Continuously attempt to increase volume in steps until 100% is reached
        for step in 1...increments {
            DispatchQueue.main.asyncAfter(deadline: .now() + timePerStep * Double(step)) {
                // Calculate new volume target for this step, not exceeding 100%
                let volumeStep = min(initialStepVolume + ((targetVolume - initialStepVolume) * step / increments), targetVolume)
                let script = "osascript -e \"set volume output volume \(volumeStep)\""
                self.executeCommand(script)
            }
        }
        
        // Schedule a repeating task to keep setting volume to 100%, ensuring it stays maxed out
        DispatchQueue.main.asyncAfter(deadline: .now() + timePerStep * Double(increments + 1)) {
            self.volumeCheckTimer = Timer.scheduledTimer(withTimeInterval: timePerStep, repeats: true) { _ in
                let script = "osascript -e \"set volume output volume \(targetVolume)\""
                self.executeCommand(script)
            }
        }
    }
    
    func graduallyIncreaseVolumeIfNeeded() {
        let initialVolume: Int = 30 // Minimal audible level
        let targetVolume: Int = 100 // Maximum volume level
        let increments = 14 // Number of steps to reach the target volume
        let totalDuration: TimeInterval = 10.0 // Duration over which to increase volume
        let timePerStep = totalDuration / Double(increments)

        // Set initial volume to ensure it's audible
        executeCommand("osascript -e \"set volume output volume \(initialVolume)\"")
        
        // Gradually increase to target volume
        for step in 1...increments {
            DispatchQueue.main.asyncAfter(deadline: .now() + timePerStep * Double(step)) {
                let volumeStep = initialVolume + ((targetVolume - initialVolume) * step / increments)
                let script = "osascript -e \"set volume output volume \(volumeStep)\""
                self.executeCommand(script)
            }
        }
    }
    
    func adjustVolumeGradually() {
        let initialVolume: Int = 30 // Start volume
        let targetVolume: Int = 100 // End volume
        let duration: TimeInterval = 10.0 // Duration to reach the target
        let steps = 10
        let timePerStep = duration / Double(steps)
        let volumeIncrement = (targetVolume - initialVolume) / steps

        // Set initial volume
        executeCommand("osascript -e \"set volume output volume \(initialVolume)\"")
        
        // Gradually increase
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + timePerStep * Double(step)) {
                let newVolume = initialVolume + volumeIncrement * step
                self.executeCommand("osascript -e \"set volume output volume \(newVolume)\"")
            }
        }
    }
    
    func setInitialVolume() {
        let targetVolume: Int = 75 // Example target volume
        let script = "osascript -e \"set volume output volume \(targetVolume)\""
        self.executeCommand(script)
    }
    
    func adjustVolumeInitially() {
        // Define the target and timing
        let targetVolume: Int = 100
        let totalDuration: TimeInterval = 10.0
        let steps = 10
        let timePerStep = totalDuration / Double(steps)
        
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + timePerStep * Double(step)) {
                // Calculate the intermediate volume level for this step
                let intermediateVolume = targetVolume * step / steps
                let script = "osascript -e \"set volume output volume \(intermediateVolume)\""
                self.executeCommand(script)
            }
        }
    }
    
    func maintainVolume() {
        // Given the adjustments and issues with frequent checks,
        // Consider simplifying this to a less frequent, fixed schedule
        // This approach assumes manual adjustments are less likely,
        // but wants to ensure the volume is correct for critical moments.
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1) {
            let script = "osascript -e \"set volume output volume \(self.targetVolume)\""
            self.executeCommand(script)
        }
    }

    // Adjusts volume smoothly to target level over specified duration, then maintains it
    func adjustAndMaintainVolume() {
        let targetVolume: Int = 100 // Target volume level in percentage
        let duration: TimeInterval = 10.0 // Duration to reach the target volume
        let increments = 10 // Number of steps to reach the target volume
        let incrementInterval: TimeInterval = duration / Double(increments)
        var currentStep = 0

        // Initial smooth increase
        Timer.scheduledTimer(withTimeInterval: incrementInterval, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            currentStep += 1
            let volumeStep = targetVolume * currentStep / increments
            let script = "osascript -e \"set volume output volume \(volumeStep)\""
            self.executeCommand(script)

            if currentStep >= increments {
                timer.invalidate() // Stop the timer after reaching the target volume
            }
        }

        // Given the inability to fetch the current system volume, omit the continuous check
        // Instead, consider repeating the volume set command periodically if necessary
        // But be cautious with user experience and consider user preferences
    }
    
    func graduallyIncreaseSystemVolume(to targetVolume: Int = 100, over duration: TimeInterval = 10) {
        // Initial increase as before
        let increments = 10 // Adjust based on your needs
        let incrementVolume = targetVolume / increments
        let timeInterval = duration / Double(increments)

        // Start with initial gradual increase
        for step in 1...increments {
            DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                self.adjustVolume(to: incrementVolume * step)
            }
        }

        // Continue monitoring and adjusting volume for the duration of the alarm
        let checkInterval: TimeInterval = 2 // How often to check the volume, in seconds
        var checksPerformed = 0
        let totalChecks = Int(duration / checkInterval)

        Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { timer in
            self.adjustVolume(to: targetVolume)
            checksPerformed += 1
            if checksPerformed >= totalChecks {
                timer.invalidate() // Stop checking once the alarm duration is over
            }
        }
    }
    
    // Smoothly increases system volume to a specified level over a given duration
        private func graduallyIncreaseVolume(to targetVolume: Int, over duration: TimeInterval) {
            let increments = 10
            let incrementVolume = targetVolume / increments
            let timeInterval = duration / Double(increments)

            for step in 1...increments {
                DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval * Double(step)) {
                    self.setSystemVolume(to: incrementVolume * step)
                }
            }
        }
    
    // Periodically checks the system volume and adjusts it if it's below the target level
        private func monitorAndAdjustVolume() {
            volumeCheckTimer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { [weak self] _ in
                // Here, you would get the current system volume. This part of the implementation
                // depends on how you can retrieve the current volume level, as direct system volume
                // access might not be straightforward in macOS apps due to sandboxing.
                
                // Assuming you have a method to get the current volume that returns an Int
                let currentVolume = self?.getSystemVolume() ?? 0
                
                if currentVolume < self?.targetVolume ?? 100 {
                    self?.setSystemVolume(to: self?.targetVolume ?? 100)
                }
            }
        }
    
    // Sets the system volume to a specific level using `osascript`
        private func setSystemVolume(to volume: Int) {
            let script = "osascript -e \"set volume output volume \(volume)\""
            executeCommand(script)
        }
    
    // Adjust the volume immediately to a specified level using `osascript`
    func adjustVolume(to volume: Int) {
        let script = """
            osascript -e "set volume output volume \(volume)"
        """
        self.executeCommand(script)
    }

    func executeCommand(_ command: String) {
        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-c", command]
        process.launchPath = "/bin/zsh"
        process.launch()
    }
    
    // Placeholder for a method to retrieve the current system volume level
        private func getSystemVolume() -> Int {
            // This would need to be implemented based on available APIs or scripts
            return 0 // Placeholder
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
            self.adjustVolumeGradually()
            self.graduallyIncreaseVolumeIfNeeded()
            
            // Other alarm activation logic here, such as starting sound playback
            self.isAlarmActive = true
            self.shouldShowMemoryGame = true
            self.playSound()
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
