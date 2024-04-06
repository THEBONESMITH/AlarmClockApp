//
//  MemoryGameViewModel.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

class MemoryGameViewModel: ObservableObject {
    @Published var tiles: [MemoryTile] = []

    init() {
        resetGame()
    }

    // Define the tileTapped method
        func tileTapped(_ tile: MemoryTile) {
            // Find the index of the tapped tile
            if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
                // Toggle the isRevealed state or any other game logic
                withAnimation {
                    tiles[index].isRevealed.toggle()
                }
            }
        }
    
    func resetGame() {
        // Assuming 25 tiles in total and a sequence of 7 correct tiles
        tiles = setupTiles(numTiles: 25)
    }

    private func setupTiles(numTiles: Int) -> [MemoryTile] {
            let sequence = generateSequence(length: 7, numTiles: numTiles)
            return (0..<numTiles).map { index in
                MemoryTile(isRevealed: false, isCorrect: sequence.contains(index), color: getRandomPastelColor())
            }
        }

    private func generateSequence(length: Int, numTiles: Int) -> [Int] {
        var sequence = [Int]()
        while sequence.count < length {
            let tile = Int.random(in: 0..<numTiles)
            if !sequence.contains(tile) {
                sequence.append(tile)
            }
        }
        return sequence
    }

    private func getRandomPastelColor() -> Color {
        let red = Double.random(in: 150...255) / 255.0
        let green = Double.random(in: 150...255) / 255.0
        let blue = Double.random(in: 150...255) / 255.0
        return Color(red: red, green: green, blue: blue)
    }
}
