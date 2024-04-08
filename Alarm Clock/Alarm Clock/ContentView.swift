//
//  ContentView.swift
//  Alarm Clock
//
//  Created by . . on 05/04/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var alarmManager: AlarmManager
    @State private var selectedHour = Calendar.current.component(.hour, from: Date())
    @State private var selectedMinute = Calendar.current.component(.minute, from: Date())
    @State private var isAlarmSet = false

    var body: some View {
        VStack {
            // Time setting UI
            HStack {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Picker("Minute", selection: $selectedMinute) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .disabled(isAlarmSet) // Disable the pickers when the alarm is set
            
            // Buttons for setting/canceling the alarm and resetting the time
            Button(action: {
                if isAlarmSet {
                    // Cancel the alarm
                    alarmManager.cancelAlarm()
                    isAlarmSet = false
                } else {
                    // Set the alarm
                    alarmManager.setAlarm(hour: selectedHour, minute: selectedMinute)
                    isAlarmSet = true
                }
            }) {
                Text(isAlarmSet ? "Cancel Alarm" : "Set Alarm")
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("Reset to Current Time") {
                let now = Date()
                selectedHour = Calendar.current.component(.hour, from: now)
                selectedMinute = Calendar.current.component(.minute, from: now)
                if isAlarmSet {
                    alarmManager.cancelAlarm()
                    isAlarmSet = false
                }
            }
            .buttonStyle(.bordered)
            .padding()

            // "Toggle Grid" button to manually show/hide the memory game for testing
            Button("Toggle Grid") {
                print("Toggling Grid: \(alarmManager.shouldShowMemoryGame)")
                alarmManager.shouldShowMemoryGame.toggle()
            }
        }
        .onChange(of: alarmManager.shouldShowMemoryGame, initial: alarmManager.shouldShowMemoryGame) { _, newShouldShow in
                    if newShouldShow {
                        // Actions to perform when shouldShowMemoryGame changes to true
                        print("Memory game should show now.")
                    } else {
                        // Optionally, actions to perform when shouldShowMemoryGame changes to false
                        print("Memory game should hide now.")
                    }
            // Optionally force a view update here if needed
        }
        // Depending on your app design, decide how you want to present the MemoryGameView
        // For example, using a sheet, fullScreenCover (not available on macOS), or another custom view
        // Ensure that such presentation logic is correctly integrated here
        .sheet(isPresented: $alarmManager.shouldShowMemoryGame) {
            MemoryGameView(viewModel: MemoryGameViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(alarmManager: AlarmManager())
    }
}
