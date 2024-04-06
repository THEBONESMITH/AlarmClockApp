//
//  MemoryGameView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel // Ensure this matches your actual ViewModel name and it's initialized correctly
    private let columns: [GridItem] = Array(repeating: .init(.fixed(60), spacing: 10), count: 5)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.tiles.indices, id: \.self) { index in
                    let tile = viewModel.tiles[index]
                    Rectangle()
                        .fill(tile.isRevealed ? viewModel.currentRoundColor : Color.gray) // Use correct property name here
                        .frame(width: 60, height: 60)
                        .onTapGesture {
                            viewModel.tileTapped(index) // Assuming your ViewModel has this method
                        }
                }
            }
            .padding(10)
        }
        .background(Color.black.opacity(0.8))
        .onAppear {
            viewModel.setupGame() // Ensure this method exists and is correctly implemented in your ViewModel
        }
    }
}

// Demo purposes ViewModel init in the View directly, in practice, you might want to inject it
struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(viewModel: MemoryGameViewModel())
    }
}
