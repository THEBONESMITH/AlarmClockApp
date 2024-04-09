//
//  PuzzleView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import SwiftUI

struct PuzzleView: View {
    @Binding var isPresented: Bool
    private let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    @State private var tiles: [Tile] = (0..<25).map { _ in Tile() }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: gridLayout, spacing: 10) {
                ForEach(tiles) { tile in
                    Rectangle()
                        .foregroundColor(tile.isRevealed ? .green : Color(red: 0.5, green: 0.5, blue: 0.5))
                        .aspectRatio(1, contentMode: .fit)
                        .border(Color.white, width: 1)
                        .onTapGesture {
                            tileTapped(tile)
                        }
                }
            }
            .padding(20)
            .background(Color.black.opacity(0.8))
        }
        // Set both minWidth and maxWidth to the same value to prevent resizing
        // Same for minHeight and maxHeight
        .frame(minWidth: 500, maxWidth: 500, minHeight: 500, maxHeight: 500)
        .onAppear {
            setupGame()
        }
    }
    
    private func tileTapped(_ tile: Tile) {
            guard let index = tiles.firstIndex(where: { $0.id == tile.id }) else { return }
            withAnimation {
                tiles[index].isRevealed.toggle()
            }
        }
        
        private func setupGame() {
            // Shuffle the tiles or perform other setup tasks here.
            tiles.shuffle()
        }
    }

    struct Tile: Identifiable {
        let id = UUID()
        var isRevealed: Bool = false
    }

    // Preview for the PuzzleView
    struct PuzzleView_Previews: PreviewProvider {
        static var previews: some View {
            PuzzleView(isPresented: .constant(true))
        }
    }
