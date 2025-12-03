import SwiftUI

/// Reusable card view for displaying volcano parts with animations
struct VolcanoPartCardView: View {
    let part: VolcanoPartInfo
    let stepNumber: Int
    let totalSteps: Int
    @State private var isAnimating = false
    @State private var showFullDescription = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Large emoji icon with animation
            Text(part.emoji)
                .font(.system(size: 100))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                .animation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Part name
            Text(part.name)
                .font(AppTheme.Typography.pageTitleFont)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .shadow(color: .black.opacity(0.5), radius: 5)
            
            // Short description
            Text(part.shortDescription)
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
                        .fill(part.color.opacity(0.8))
                )
            }
            
            // Expandable full description
            if showFullDescription {
                VStack(spacing: AppTheme.Spacing.medium) {
                    // Full description
                    Text(part.fullDescription)
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale))
                    
                    // Micro story in a special box
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        HStack {
                            Text("📖")
                                .font(.system(size: 24))
                            Text("Story Time!")
                                .font(.custom("Noteworthy-Bold", size: 20))
                                .foregroundColor(.yellow)
                        }
                        
                        Text(part.microStory)
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
                            part.color.opacity(0.4),
                            part.color.opacity(0.2),
                            Color.black.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: part.color.opacity(0.5), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(
                    LinearGradient(
                        colors: [part.color, part.color.opacity(0.3)],
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

