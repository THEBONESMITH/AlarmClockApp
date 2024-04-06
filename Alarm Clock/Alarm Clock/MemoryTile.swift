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
    var isRevealed: Bool = false
    var isMatched: Bool = false
    var color: Color = .gray
}
