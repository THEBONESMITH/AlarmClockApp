//
//  StartScreenView.swift
//  Alarm Clock
//
//  Created by . . on 08/04/2024.
//

import Foundation
import SwiftUI

struct StartScreenView: View {
    var onStart: () -> Void
    
    var body: some View {
        VStack {
            Button(action: onStart) {
                Text("Start")
                    .font(.largeTitle)  // Increase font size for the button text
                    .padding()     // Add padding for a larger clickable area
            }
            .buttonStyle(.borderedProminent)
            .padding(15)  // Additional padding around the button
            .frame(maxWidth: 200, maxHeight: 50)  // Set fixed width and height
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.8))
        .foregroundColor(.white)
    }
}
