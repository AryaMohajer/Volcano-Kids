import SwiftUI

struct PuzzleRowView: View {
    let puzzle: PuzzleItem
    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 12) {
            // Circular icon with red border - optimized size
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primaryBackground)
                    .frame(width: 70, height: 70)
                
                Image(puzzle.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
            }
            .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)

            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(puzzle.title)
                    .font(.custom("Noteworthy-Bold", size: 19))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(puzzle.subtitle)
                    .font(.custom("Noteworthy-Bold", size: 15))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 8)
            
            // Chevron indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(isPressed ? 0.1 : 0.05))
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
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
