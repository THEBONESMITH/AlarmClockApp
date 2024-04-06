//
//  TileView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct TileView: View {
    var tile: MemoryTile
    var action: () -> Void

    var body: some View {
        Rectangle()
            .fill(tile.isRevealed ? Color.green : Color.gray)
            .aspectRatio(1, contentMode: .fit) // This should maintain a 1:1 aspect ratio
            .onTapGesture(perform: action)
            .border(Color.white, width: 1)
    }
}
