import SwiftUI

struct PuzzleView: View {
    @StateObject private var viewModel: PuzzleViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showCompletion = false
    
    init(selectedPuzzleIndex: Int) {
        let viewModel = PuzzleViewModel()
        viewModel.selectedPuzzleIndex = selectedPuzzleIndex
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // Beautiful gradient background matching app theme
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.0, blue: 0.1),
                    AppTheme.Colors.primaryBackground,
                    AppTheme.Colors.accent.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Sliding Puzzle")
                    .font(.custom("Noteworthy-Bold", size: 36))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                Text("Moves: \(viewModel.moveCount)")
                    .font(.custom("Noteworthy-Bold", size: 20))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 10)
                
                // Puzzle layout with better styling
                VStack(spacing: 4) {
                    ForEach(0..<viewModel.rows, id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<viewModel.columns, id: \.self) { col in
                                let coord = Coord(x: col, y: row)
                                puzzleCell(coord)
                                    .frame(width: AppTheme.Sizes.puzzleTileSize, height: AppTheme.Sizes.puzzleTileSize)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2)
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.3))
                        .shadow(radius: 10)
                )
                .padding(.horizontal)
                
                // Control buttons with better styling
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            viewModel.shuffle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                            Text("Shuffle")
                        }
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.Colors.accent)
                        )
                    }
                    
                    Button(action: {
                        withAnimation {
                            viewModel.sort()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.8))
                        )
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.moveCount) { _ in
            if viewModel.isPuzzleComplete() {
                showCompletion = true
                // Haptic feedback
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
        .alert("🎉 Congratulations!", isPresented: $showCompletion) {
            Button("Awesome!") { }
        } message: {
            Text("You solved the puzzle in \(viewModel.moveCount) moves!")
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
