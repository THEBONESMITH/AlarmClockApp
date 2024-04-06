//
//  MemoryTile.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct MemoryTile: Identifiable {
    let id: UUID = UUID() // Ensures each tile has a unique ID
    var isRevealed: Bool = false
    var isCorrect: Bool = false // Tracks if this tile is part of the correct sequence
    var color: Color = .gray // The color of the tile
}
