import SwiftUI

struct PuzzleDetailView: View {
    let puzzle: PuzzleItem

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    AppTheme.Colors.primaryBackground,
                    AppTheme.Colors.accent
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack {
                    Image(puzzle.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding()

                    Text(puzzle.title)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .font(.title)
                        .bold()
                        .padding()

                    Text(puzzle.text)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .padding()
                    
                    Spacer()

                    // Navigation to PuzzleView
                    NavigationLink(destination: PuzzleView(selectedPuzzleIndex: puzzle.puzzleIndex)) {
                        Text("Start The Game")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.Colors.accent)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Puzzle Details")
    }
}
