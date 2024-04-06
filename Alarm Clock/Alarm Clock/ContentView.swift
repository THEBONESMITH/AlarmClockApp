//
//  ContentView.swift
//  Alarm Clock
//
//  Created by . . on 05/04/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var alarmManager = AlarmManager()
    @State private var selectedHour = Calendar.current.component(.hour, from: Date())
    @State private var selectedMinute = Calendar.current.component(.minute, from: Date())
    @State private var isAlarmSet = false
    @State private var showPuzzle = false
    
    var body: some View {
            VStack {
                Text(isAlarmSet ? "Alarm is set" : "Set Alarm")
                    .font(.largeTitle)
                
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
                
                Button(action: {
                    if self.isAlarmSet {
                        // Cancel the alarm if it is already set
                        self.alarmManager.cancelAlarm()
                        self.isAlarmSet = false
                    } else {
                        // Get the current time
                        let now = Date()
                        let calendar = Calendar.current
                        let currentHour = calendar.component(.hour, from: now)
                        let currentMinute = calendar.component(.minute, from: now)
                        
                        // Set the alarm (which includes immediate triggering logic if the times match)
                        self.alarmManager.setAlarm(hour: self.selectedHour, minute: self.selectedMinute)
                        
                        // Determine if the puzzle should be shown immediately (i.e., the times match)
                        if self.selectedHour == currentHour && self.selectedMinute == currentMinute {
                            // The selected time matches the current time, so show the puzzle and play the sound immediately.
                            self.showPuzzle = true
                            // Note: Ensure playSound() is designed to be safely called here if needed for immediate sound playback.
                            // self.alarmManager.playSound() // Uncomment if playSound should be called directly here.
                        }
                        
                        self.isAlarmSet = true
                    }
                }) {
                    Text(isAlarmSet ? "Cancel Alarm" : "Set Alarm")
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                // Reset button
                Button("Reset to Current Time") {
                    let now = Date()
                    self.selectedHour = Calendar.current.component(.hour, from: now)
                    self.selectedMinute = Calendar.current.component(.minute, from: now)
                    
                    // Optionally, cancel the alarm if it was set
                    if self.isAlarmSet {
                        self.alarmManager.cancelAlarm()
                        self.isAlarmSet = false
                    }
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .padding()
            .sheet(isPresented: $showPuzzle) {
                PuzzleView(isPresented: $showPuzzle)
            }
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
