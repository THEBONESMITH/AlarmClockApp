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
    let columns = [GridItem](repeating: .init(.flexible()), count: 5)
    @State var tiles: [Tile] = (0..<25).map { Tile(id: $0) }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(tiles) { tile in
                    Rectangle()
                        .foregroundColor(tile.isRevealed ? .blue : .gray)
                        .frame(height: 60)
                        .onTapGesture {
                            // Handle tile tap
                        }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .onAppear {
            // Prepare the puzzle game
        }
    }
}

struct Tile: Identifiable {
    let id: Int
    var isRevealed: Bool = false
}
