//
//  MemoryGameView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel

    private let columns: [GridItem] = Array(repeating: .init(.fixed(60), spacing: 10), count: 5)

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.tiles, id: \.id) { tile in
                        Rectangle()
                            .fill(tile.isRevealed ? (tile.isCorrect ? viewModel.currentRoundColor : Color.red) : Color.gray)
                            .frame(width: 60, height: 60)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 1), value: tile.isRevealed)
                    }
                }
                .padding(10)
            }
        }
        .onAppear {
            viewModel.revealCorrectTilesTemporarily()
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
