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
    private var revealTimer: AnyCancellable?

    init() {
        setupGame()
    }
    
    func revealCorrectTilesTemporarilyWithAnimation() {
        // Reveal correct tiles with an animation
        for index in tiles.indices where tiles[index].isCorrect {
            withAnimation(Animation.linear(duration: 0.5).delay(0.5)) {
                tiles[index].isRevealed = true
            }
        }
        
        // Hide the tiles after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            for index in self.tiles.indices where self.tiles[index].isCorrect {
                withAnimation(Animation.linear(duration: 0.5).delay(0.5)) {
                    self.tiles[index].isRevealed = false
                }
            }
        }
    }
    
    func revealCorrectTilesTemporarily() {
        // First, ensure all correct tiles are revealed.
        for index in tiles.indices where tiles[index].isCorrect {
            tiles[index].isRevealed = true
        }
        
        // Force SwiftUI to recognize the change by reassigning the tiles array.
        self.tiles = self.tiles.map { $0 }
        // No need for objectWillChange.send() since we're updating @Published property

        // Schedule the reversal after a brief delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }

            for index in self.tiles.indices where self.tiles[index].isCorrect {
                self.tiles[index].isRevealed = false
            }
            
            // Again, force SwiftUI to recognize the change by reassigning the tiles array.
            self.tiles = self.tiles.map { $0 }
            // As before, no need for objectWillChange.send() here
        }
    }
    
    func setupGame() {
            // Initialize a set to keep track of which tiles are correct.
            var correctIndices: Set<Int> = []
            while correctIndices.count < 7 {
                correctIndices.insert(Int.random(in: 0..<25))
            }
            
            self.tiles = (0..<25).map { index in
                // Assuming MemoryTile takes only a 'isCorrect' parameter for simplicity.
                MemoryTile(isRevealed: false, isCorrect: correctIndices.contains(index))
            }
            currentRoundColor = getRandomPastelColor()
            
            // Schedule the reveal of correct tiles after a brief delay to ensure UI is ready.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.revealCorrectTilesTemporarily()
            }
        }

        private func hideTiles() {
            for index in tiles.indices {
                tiles[index].isRevealed = false
            }
        }
        
        func tileTapped(at index: Int) {
            guard tiles.indices.contains(index) else { return }
            tiles[index].isRevealed.toggle()
        }
        
        private func getRandomPastelColor() -> Color {
            let r = Double.random(in: 150...255) / 255.0
            let g = Double.random(in: 150...255) / 255.0
            let b = Double.random(in: 150...255) / 255.0
            return Color(red: r, green: g, blue: b)
        }
    }
