//
//  PuzzleView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct PuzzleView: View {
    @Binding var isPresented: Bool
    private let rows = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    @State var tiles: [Tile] = (0..<25).map { Tile(id: $0) }

    var body: some View {
        VStack {
            LazyVGrid(columns: rows, spacing: 10) {
                ForEach(tiles) { tile in
                    Rectangle()
                        .foregroundColor(tile.isRevealed ? .blue : .gray)
                        .aspectRatio(1, contentMode: .fit) // Enforce a 1:1 aspect ratio
                        .onTapGesture {
                            // Handle tile tap
                        }
                }
            }
            .padding(10)
            .background(Color.black.opacity(0.8))
        }
        .onAppear {
            // Prepare the puzzle game
        }
    }
}

struct Tile: Identifiable {
    let id: Int
    var isRevealed: Bool = false
}
