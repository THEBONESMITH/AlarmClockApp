//
//  Alarm_ClockApp.swift
//  Alarm Clock
//
//  Created by . . on 05/04/2024.
//

import SwiftUI

@main
struct Alarm_ClockApp: App {
    // Create an instance of AlarmManager
    var alarmManager = AlarmManager()

    var body: some Scene {
        WindowGroup {
            // Only AlarmManager is passed to ContentView.
            // MemoryGameViewModel should be initialized inside ContentView.
            ContentView(alarmManager: alarmManager)
        }
    }
}
