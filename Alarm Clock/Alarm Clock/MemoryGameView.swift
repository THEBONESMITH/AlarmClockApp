//
//  MemoryGameView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct MemoryGameView: View {
    @State private var tiles: [MemoryTile] = (0..<25).map { _ in MemoryTile(id: UUID()) }
    private let tileCount = 5 // Number of tiles in one row
    private let tileSpacing: CGFloat = 10
    private let tileSideLength: CGFloat = 60 // You can adjust this as needed

    // Use this to create equally sized columns
    private var columns: [GridItem] {
        Array(repeating: .init(.fixed(tileSideLength), spacing: tileSpacing), count: tileCount)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: tileSpacing) {
                ForEach(tiles) { tile in
                    TileView(tile: tile) {
                        self.tileTapped(tile)
                    }
                    .frame(width: tileSideLength, height: tileSideLength)
                }
            }
            .padding(.horizontal, tileSpacing)
        }
        .padding(.top, tileSpacing) // Add padding at the top
        .background(Color.black.opacity(0.8)) // The background for the grid
    }
    
    // A method within the view struct to handle tile taps
    private func tileTapped(_ tile: MemoryTile) {
        guard let index = tiles.firstIndex(where: { $0.id == tile.id }) else { return }
        // Perform your logic for when a tile is tapped
    }

    private func revealTile(_ tile: MemoryTile) {
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            // We found the index of the tile that was tapped
            withAnimation {
                tiles[index].isRevealed.toggle() // This line uses 'index'
            }
            // Here you might want to add additional logic to handle the game's state
            // For example, you might want to check if two tiles are revealed and they match
        }
    }

    private func checkForMatch(_ firstIndex: Int, _ secondIndex: Int) {
        // Game logic to determine if two tiles match
    }

    private func resetGame() {
        // Game logic to reset the game for a new round
    }
}
