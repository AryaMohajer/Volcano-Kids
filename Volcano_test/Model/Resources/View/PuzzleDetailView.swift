import SwiftUI

struct PuzzleDetailView: View {
    let puzzle: PuzzleItem
    @Environment(\.presentationMode) var presentationMode

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
                VStack(spacing: AppTheme.Spacing.large) {
                    // Circular icon with red border
                    Image(puzzle.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: AppTheme.Sizes.detailIconSize, height: AppTheme.Sizes.detailIconSize)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(AppTheme.Colors.primaryBackground, lineWidth: 4)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.top, AppTheme.Spacing.medium)

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
        .navigationBarBackButtonHidden(true)
    }
}
