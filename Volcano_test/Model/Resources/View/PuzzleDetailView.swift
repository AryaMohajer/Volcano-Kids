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

            VStack(spacing: 0) {
                // Header with back button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Back")
                                .font(.custom("Noteworthy-Bold", size: 17))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.top, AppTheme.Spacing.small)
                
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
                            .font(.custom("Noteworthy-Bold", size: 32))
                            .shadow(color: .black.opacity(0.5), radius: 5)
                            .padding()

                        Text(puzzle.text)
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .font(.custom("Noteworthy-Bold", size: 18))
                            .multilineTextAlignment(.leading)
                            .padding()
                        
                        Spacer()
                            .frame(height: AppTheme.Spacing.medium)

                        // Navigation to PuzzleView
                        NavigationLink(destination: PuzzleView(selectedPuzzleIndex: puzzle.puzzleIndex)) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start The Game")
                            }
                            .font(.custom("Noteworthy-Bold", size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal, AppTheme.Spacing.extraLarge)
                            .padding(.vertical, AppTheme.Spacing.medium)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                    .fill(
                                        LinearGradient(
                                            colors: [.orange, .red],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, AppTheme.Spacing.extraLarge)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
