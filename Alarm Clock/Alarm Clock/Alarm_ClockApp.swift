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
            // Pass the instance to ContentView
            ContentView(alarmManager: alarmManager)
        }
    }
}
