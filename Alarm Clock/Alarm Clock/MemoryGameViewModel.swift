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
    @Published var isWaitingForReset: Bool = false
    @Published var isRevealingTiles: Bool = false
    private var revealTimer: AnyCancellable?
    
    // Add a reference to AlarmManager
    var alarmManager: AlarmManager

    // Update the initializer to accept an AlarmManager instance
    init(alarmManager: AlarmManager) {
        self.alarmManager = alarmManager
        setupGame()
    }
    
    func toggleTile(_ id: UUID) {
        // Check if the game is currently revealing tiles or waiting for reset
        if isWaitingForReset || isRevealingTiles {
            return
        }

        if let index = tiles.firstIndex(where: { $0.id == id }) {
            tiles[index].isRevealed = true
            
            if !tiles[index].isCorrect {
                isWaitingForReset = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    self?.resetGameForNewRound()
                }
            } else {
                if checkForWin() {
                    // Reduced delay here, for example, to 0.75 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
                        self?.endGame()
                    }
                }
            }
        }
    }
    
    func resetGameForNewRound() {
        isWaitingForReset = false // Allow tile interactions again
        var correctIndices: Set<Int> = []
        while correctIndices.count < 7 {
            correctIndices.insert(Int.random(in: 0..<25))
        }
        
        self.tiles = (0..<25).map { index in
            MemoryTile(isRevealed: false, isCorrect: correctIndices.contains(index))
        }
        currentRoundColor = getRandomPastelColor()
        
        // Optionally, you might want to reveal the correct tiles temporarily here as well
        revealCorrectTilesTemporarily()
        alarmManager.graduallyIncreaseVolumeIfNeeded()
    }

    private func checkForWin() -> Bool {
        let allCorrectTilesRevealed = tiles.filter { $0.isCorrect }.allSatisfy { $0.isRevealed }
        if allCorrectTilesRevealed {
            print("All correct tiles revealed. Player has won.")
            return true
        }
        return false
    }
    
    func endGame() {
        alarmManager.turnOffAlarm()
        // Any additional logic needed to reset the game state or prepare for a new game can go here
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
        isRevealingTiles = true  // Start revealing tiles
        
        for index in tiles.indices where tiles[index].isCorrect {
            tiles[index].isRevealed = true
        }
        self.tiles = self.tiles.map { $0 }  // Ensure UI updates
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }

            for index in self.tiles.indices where self.tiles[index].isCorrect {
                self.tiles[index].isRevealed = false
            }
            self.tiles = self.tiles.map { $0 }  // Ensure UI updates again
            
            self.isRevealingTiles = false  // Done revealing tiles
        }
    }
    
    func setupGame() {
        var correctIndices: Set<Int> = []
        while correctIndices.count < 7 {
            correctIndices.insert(Int.random(in: 0..<25))
        }

        self.tiles = (0..<25).map { index in
            MemoryTile(isRevealed: false, isCorrect: correctIndices.contains(index))
        }
        currentRoundColor = getRandomPastelColor()

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
