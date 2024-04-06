//
//  MemoryTile.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
import SwiftUI

struct MemoryTile: Identifiable {
    let id: UUID
    var isRevealed: Bool
    var isCorrect: Bool
    // Consider adding color here if tiles have individual colors
}
