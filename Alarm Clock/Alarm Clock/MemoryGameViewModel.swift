//
//  MemoryGameViewModel.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import SwiftUI
import Combine

class MemoryGameViewModel: ObservableObject {
    @Published var tiles: [MemoryTile] = []
    @Published var currentRoundColor: Color = .gray
    private var correctTiles = Set<UUID>()
    private var revealTimer: AnyCancellable?

    init() {
        setupGame()
    }
    
    func testRevealTiles() {
        for index in tiles.indices {
            tiles[index].isRevealed = tiles[index].isCorrect
        }
    }

    func setupGame() {
        // Decide how many tiles you want to be correct.
        let numberOfCorrectTiles = 7
        
        // Generate a set of unique indices for the correct tiles.
        var correctIndices: Set<Int> = []
        while correctIndices.count < numberOfCorrectTiles {
            correctIndices.insert(Int.random(in: 0..<25))
        }
        
        // Map each index to a MemoryTile, marking it as correct if its index is in the correctIndices set.
        tiles = (0..<25).map { index in MemoryTile(isCorrect: correctIndices.contains(index)) }
        
        // Initially reveal correct tiles.
        revealCorrectTiles()
    }

    func revealCorrectTiles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tiles.indices.forEach { index in
                if self.tiles[index].isCorrect {
                    self.tiles[index].isRevealed = true
                    self.correctTiles.insert(self.tiles[index].id)
                }
            }
            self.hideTilesAfterDelay()
        }
    }

    func hideTilesAfterDelay() {
        revealTimer = Just(true)
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.tiles.indices.forEach { index in
                    self?.tiles[index].isRevealed = false
                }
            }
    }

    func tileTapped(at index: Int) {
        // You already have the index, so there's no need to find it again.
        // Ensure the index is within bounds to avoid out-of-range errors.
        guard tiles.indices.contains(index) else { return }

        // Use the index directly to access the tile in the tiles array.
        if correctTiles.contains(tiles[index].id) {
            // You directly toggle the isRevealed state of the tile at the given index.
            tiles[index].isRevealed = !tiles[index].isRevealed
        }
    }
}
