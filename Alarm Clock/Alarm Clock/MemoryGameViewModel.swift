//
//  MemoryGameViewModel.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI
import Combine

class MemoryGameViewModel: ObservableObject {
    @Published var tiles: [MemoryTile] = []
    private var correctSequence: Set<Int> = []
    private var revealTimer: AnyCancellable?
    
    // This property can be used by the view to apply the round's color.
    @Published var currentRoundColor: Color = .gray

    init() {
        setupGame()
    }

    func setupGame() {
        correctSequence = generateSequence(length: 7, numTiles: 25)
        currentRoundColor = getRandomPastelColor() // Set the color for the new round
        tiles = (0..<25).map { index in
            MemoryTile(id: UUID(), isRevealed: false, isCorrect: correctSequence.contains(index))
        }
        // Reveal correct tiles initially and then hide them after a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.revealCorrectTiles()
        }
    }
    
    private func revealCorrectTiles() {
        // Reveal correct tiles initially
        tiles.indices.forEach { index in
            tiles[index].isRevealed = tiles[index].isCorrect
        }

        // Flip them back over after a short delay
        revealTimer = Just(())
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.hideTiles()
            }
    }

    private func hideTiles() {
        // Hide all tiles
        tiles.indices.forEach { index in
            tiles[index].isRevealed = false
        }
        // Notify the view to update since we're changing the state directly
        self.objectWillChange.send()
    }
    
    func tileTapped(_ index: Int) {
        // Process a tile tap, determining if it's a correct guess
        withAnimation {
            if tiles[index].isCorrect {
                // Correct tiles reveal in the round's color
                tiles[index].isRevealed = true
            } else {
                // Incorrect guess logic here
                // Temporarily show incorrect guess, then flip back
            }
        }
    }

    private func generateSequence(length: Int, numTiles: Int) -> Set<Int> {
        return Set((0..<numTiles).shuffled().prefix(length))
    }

    private func getRandomPastelColor() -> Color {
        let r = Double.random(in: 150...255) / 255.0
        let g = Double.random(in: 150...255) / 255.0
        let b = Double.random(in: 150...255) / 255.0
        return Color(red: r, green: g, blue: b)
    }

    func resetGame() {
        setupGame() // Resetting the game will also re-initialize the tiles and color
    }
}
