//
//  MemoryTile.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import Foundation
// MemoryTile.swift

import SwiftUI

struct MemoryTile: Identifiable {
    let id = UUID()
    var isRevealed: Bool = false
    var isCorrect: Bool = false
}
