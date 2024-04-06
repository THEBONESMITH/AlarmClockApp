//
//  MemoryGameView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel // Ensure ViewModel is correctly initialized before use

    private let columns: [GridItem] = Array(repeating: .init(.fixed(60), spacing: 10), count: 5)

    var body: some View {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.tiles) { tile in
                            Rectangle()
                                .fill(tile.isRevealed ? viewModel.currentRoundColor : Color.gray)
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    // If you need to perform actions that require the index,
                                    // find the index of the tile within this closure.
                                    if let index = viewModel.tiles.firstIndex(where: { $0.id == tile.id }) {
                                        viewModel.tileTapped(at: index)
                                    }
                                }
                        }
                    }
                    .padding(10)
                }
                .background(Color.black.opacity(0.8))

                Button("Test Reveal Tiles") {
                    viewModel.testRevealTiles()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .onAppear {
                viewModel.setupGame()
            }
        }
    }

struct TileView: View {
    var tile: MemoryTile
    var action: () -> Void

    var body: some View {
        Rectangle()
            .fill(tile.isRevealed ? (tile.isCorrect ? Color.green : Color.red) : Color.gray)
            .aspectRatio(1, contentMode: .fit)
            .onTapGesture(perform: action)
    }
}
