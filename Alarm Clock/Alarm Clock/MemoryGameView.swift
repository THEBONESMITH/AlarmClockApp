//
//  MemoryGameView.swift
//  Alarm Clock
//
//  Created by . . on 06/04/2024.
//

import SwiftUI

struct MemoryGameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    @State private var showStartScreen = true
    
    // Columns definition for your grid layout
    private let columns: [GridItem] = Array(repeating: .init(.fixed(60), spacing: 10), count: 5)

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // ScrollView adjusted to allow content to fit without being clipped
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.tiles, id: \.id) { tile in
                                TileView(viewModel: viewModel, tileId: tile.id)
                                    .frame(width: 60, height: 60)
                            }
                        }
                        // Adjust padding here if necessary
                    }
                    // Remove the frame from the ScrollView to allow it to fit content
                    Spacer()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10) // Consider moving padding here, outside of the ScrollView
            
            if showStartScreen {
                StartScreenView(onStart: {
                    withAnimation {
                        showStartScreen = false
                    }
                    viewModel.setupGame()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.revealCorrectTilesTemporarily()
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .foregroundColor(.white)
            }
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
                        .fill(tile.isRevealed ? (tile.isCorrect ? viewModel.currentRoundColor : Color.red) : Color(red: 0.4, green: 0.4, blue: 0.4)) // Darker grey
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
