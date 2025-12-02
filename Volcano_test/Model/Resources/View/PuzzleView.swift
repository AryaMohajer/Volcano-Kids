import SwiftUI

struct PuzzleView: View {
    @StateObject private var viewModel: PuzzleViewModel
    
    init(selectedPuzzleIndex: Int) {
        let viewModel = PuzzleViewModel()
        viewModel.selectedPuzzleIndex = selectedPuzzleIndex
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sliding Puzzle").font(.largeTitle).bold()
            
            Text("Moves: \(viewModel.moveCount)")
            
            // Puzzle layout
            VStack(spacing: 3) {
                ForEach(0..<viewModel.rows, id: \.self) { row in
                    HStack(spacing: 3) {
                        ForEach(0..<viewModel.columns, id: \.self) { col in
                            let coord = Coord(x: col, y: row)
                            puzzleCell(coord)
                                .frame(width: AppTheme.Sizes.puzzleTileSize, height: AppTheme.Sizes.puzzleTileSize)
                                .border(Color.gray)
                        }
                    }
                }
            }
            
            // Control buttons
            HStack {
                Button("Shuffle") {
                    viewModel.shuffle()
                }
                Button("Sort") {
                    viewModel.sort()
                }
            }
        }
        .padding()
        .onChange(of: viewModel.moveCount) { _ in
            if viewModel.isPuzzleComplete() {
                print("🎉 Puzzle solved!")
                // TODO: Add celebration animation or alert
            }
        }
    }
    
    // Single puzzle cell
    @ViewBuilder
    private func puzzleCell(_ coord: Coord) -> some View {
        if let tileCoord = viewModel.tile(at: coord) {
            Image(uiImage: viewModel.imageParts[tileCoord.x][tileCoord.y])
                .resizable()
                .scaledToFill()
                .clipped()
                .onTapGesture {
                    withAnimation {
                        viewModel.tapTile(at: coord)
                    }
                }
        } else {
            Color.clear
        }
    }
}
