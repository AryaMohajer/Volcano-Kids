import SwiftUI

struct PuzzleRowView: View {
    let puzzle: PuzzleItem

    var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            // Equal-sized icon with consistent styling and red background
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.primaryBackground)
                    .frame(width: AppTheme.Sizes.thumbnailSize, height: AppTheme.Sizes.thumbnailSize)
                
                Image(puzzle.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppTheme.Sizes.thumbnailSize, height: AppTheme.Sizes.thumbnailSize)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
            }
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(puzzle.title)
                    .font(AppTheme.Typography.headlineFont)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text(puzzle.subtitle)
                    .font(AppTheme.Typography.subheadlineFont)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
        .padding(.vertical, AppTheme.Spacing.small)
    }
}

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                AppTheme.Colors.gradientStart,
                AppTheme.Colors.gradientEnd
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct WritingMoodView: View {
    @State private var displayedText = ""
    @State private var fullText = "We're going to explore real volcanoes and hear amazing stories from people who live near them."
    @State private var wordIndex = 0

    var body: some View {
        VStack {
            Text(displayedText)
                .frame(width: 350, height: 150, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .onAppear {
                    startTypingEffect()
                }
                .onDisappear {
                    // Cleanup handled by Task cancellation
                }
        }
    }
    
    private func startTypingEffect() {
        let words = fullText.split(separator: " ").map(String.init)
        displayedText = ""
        wordIndex = 0

        Task {
            for word in words {
                try? await Task.sleep(nanoseconds: UInt64(AppTheme.Animation.typingInterval * 1_000_000_000))
                
                // Check if view is still visible
                guard !Task.isCancelled else { break }
                
                await MainActor.run {
                    displayedText += (wordIndex == 0 ? "" : " ") + word
                    wordIndex += 1
                }
            }
        }
    }
}
