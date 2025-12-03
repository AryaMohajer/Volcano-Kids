import SwiftUI

/// Card view for Earth History stages
struct EarthHistoryCardView: View {
    let stage: EarthHistoryStage
    let stepNumber: Int
    let totalSteps: Int
    @State private var isAnimating = false
    @State private var showFullDescription = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Large emoji icon with animation
            Text(stage.emoji)
                .font(.system(size: 100))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                .animation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Stage title
            Text(stage.title)
                .font(AppTheme.Typography.pageTitleFont)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .shadow(color: .black.opacity(0.5), radius: 5)
            
            // Description
            Text(stage.description)
                .font(AppTheme.Typography.bodyFont)
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
            
            // Tap to expand button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showFullDescription.toggle()
                }
            }) {
                HStack {
                    Text(showFullDescription ? "Show Less" : "Learn More")
                        .font(AppTheme.Typography.bodyFont)
                    Image(systemName: showFullDescription ? "chevron.up" : "chevron.down")
                }
                .foregroundColor(.white)
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(
                    Capsule()
                        .fill(stage.color.opacity(0.8))
                )
            }
            
            // Expandable content
            if showFullDescription {
                VStack(spacing: AppTheme.Spacing.medium) {
                    // Micro story box
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        HStack {
                            Text("📖")
                                .font(.system(size: 24))
                            Text("Story Time!")
                                .font(.custom("Noteworthy-Bold", size: 20))
                                .foregroundColor(.yellow)
                        }
                        
                        Text(stage.microStory)
                            .font(.custom("Noteworthy-Bold", size: 16))
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(Color.black.opacity(0.3))
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                .padding(.top, AppTheme.Spacing.small)
            }
        }
        .padding(AppTheme.Spacing.extraLarge)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .fill(
                    LinearGradient(
                        colors: [
                            stage.color.opacity(0.4),
                            stage.color.opacity(0.2),
                            Color.black.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: stage.color.opacity(0.5), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(
                    LinearGradient(
                        colors: [stage.color, stage.color.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
        )
        .onAppear {
            isAnimating = true
        }
    }
}

