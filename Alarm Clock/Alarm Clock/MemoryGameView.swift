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
                            TileView(viewModel: viewModel, tileId: tile.id)
                                .frame(width: 60, height: 60)
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
    @ObservedObject var viewModel: MemoryGameViewModel
    let tileId: UUID

    private var tile: MemoryTile? {
        viewModel.tiles.first { $0.id == tileId }
    }

    var body: some View {
        Group {
            if let tile = tile {
                ZStack {
                    // Decide the face of the tile based on its isRevealed state
                    Rectangle()
                        .fill(tile.isRevealed ? (tile.isCorrect ? viewModel.currentRoundColor : Color.red) : Color.gray)
                        .frame(width: 60, height: 60)
                        .onTapGesture {
                            withAnimation(Animation.easeInOut(duration: 0.5)) {
                                viewModel.toggleTile(tileId)
                            }
                        }
                }
            } else {
                // Fallback view in case tile isn't found, adjust as needed
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 60, height: 60)
            }
        }
    }
}

struct FlipEffect: GeometryEffect {
    var isFlipped: Bool
    var angle: Double
    var axis: (x: CGFloat, y: CGFloat, z: CGFloat)

    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        // Calculate the midpoint of the rotation to toggle the visibility
        let halfway = isFlipped ? -90.0 : 90.0
        let invisibilityPoint = angle < halfway || angle > halfway
        let perspective = 1.0 / -max(size.width, size.height)
        var transform3d = CATransform3DIdentity
        transform3d.m34 = perspective
        transform3d = CATransform3DRotate(transform3d, CGFloat(Angle(degrees: invisibilityPoint ? angle + 180 : angle).radians), axis.x, axis.y, axis.z)
        return ProjectionTransform(transform3d)
    }
}
