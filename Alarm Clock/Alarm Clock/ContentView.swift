//
//  ContentView.swift
//  Alarm Clock
//
//  Created by . . on 05/04/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var alarmManager: AlarmManager
    // Since MemoryGameViewModel needs to be shared or interact with AlarmManager,
    // it's better to initialize it outside and pass it to ContentView if needed.
    @StateObject var memoryGameViewModel: MemoryGameViewModel

    @State private var selectedHour = Calendar.current.component(.hour, from: Date())
    @State private var selectedMinute = Calendar.current.component(.minute, from: Date())
    @State private var isAlarmSet = false
    
    init(alarmManager: AlarmManager) {
            self.alarmManager = alarmManager
            // Initialize MemoryGameViewModel with AlarmManager internally
            _memoryGameViewModel = StateObject(wrappedValue: MemoryGameViewModel(alarmManager: alarmManager))
        }

    var body: some View {
        VStack {
            HStack {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100) // Adjust the width as needed

                Picker("Minute", selection: $selectedMinute) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)").tag(minute)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100) // Adjust the width as needed
            }
            .disabled(isAlarmSet) // Disable the pickers when the alarm is set

            // Buttons for setting/canceling the alarm and resetting the time
            Button(action: {
                if isAlarmSet {
                    alarmManager.cancelAlarm()
                    isAlarmSet = false
                } else {
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
        }
        // Listen for changes to shouldShowMemoryGame to show the MemoryGameView
        .sheet(isPresented: $alarmManager.shouldShowMemoryGame) {
            // Inject the existing ViewModel to ensure it has access to the necessary context
            MemoryGameView(viewModel: memoryGameViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Just create and pass an instance of AlarmManager to ContentView
        let previewAlarmManager = AlarmManager()
        ContentView(alarmManager: previewAlarmManager)
    }
}
