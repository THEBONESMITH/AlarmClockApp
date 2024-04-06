//
//  MemoryGameView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

// MemoryGameViewModel should be defined as shown previously
// Including generating the sequence of tiles, setting up their colors, and handling game logic

struct MemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel // Now using ViewModel to manage game state
    private let columns: [GridItem] = Array(repeating: .init(.fixed(60), spacing: 10), count: 5) // Define the layout for your grid

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.tiles) { tile in // Iterate over tiles from ViewModel
                    Rectangle()
                        .fill(tile.isRevealed ? tile.color : Color.gray) // Use the color from the ViewModel
                        .frame(width: 60, height: 60)
                        .onTapGesture {
                            viewModel.tileTapped(tile) // Handle tap via ViewModel
                        }
                }
            }
            .padding(10)
        }
        .background(Color.black.opacity(0.8))
        .onAppear {
            viewModel.resetGame() // Setup or reset the game when the view appears
        }
    }
}

// Demo purposes ViewModel init in the View directly, in practice, you might want to inject it
struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(viewModel: MemoryGameViewModel())
    }
}
