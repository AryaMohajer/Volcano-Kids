import SwiftUI

/// Reusable card view for displaying volcano types with animations
struct VolcanoTypeCardView: View {
    let volcanoType: VolcanoTypeInfo
    let stepNumber: Int
    let totalSteps: Int
    @State private var isAnimating = false
    @State private var showFullDescription = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Large emoji icon with animation
            Text(volcanoType.emoji)
                .font(.system(size: 100))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                .animation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Type name
            Text(volcanoType.name)
                .font(AppTheme.Typography.pageTitleFont)
                .foregroundColor(AppTheme.Colors.textPrimary)
                .shadow(color: .black.opacity(0.5), radius: 5)
            
            // Short description
            Text(volcanoType.shortDescription)
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
                        .fill(volcanoType.color.opacity(0.8))
                )
            }
            
            // Expandable full description
            if showFullDescription {
                VStack(spacing: AppTheme.Spacing.medium) {
                    // Full description
                    Text(volcanoType.fullDescription)
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
                        
                        Text(volcanoType.microStory)
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
                    
                    // Characteristics
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text("✨ Key Features:")
                            .font(.custom("Noteworthy-Bold", size: 20))
                            .foregroundColor(.yellow)
                        
                        ForEach(volcanoType.characteristics, id: \.self) { characteristic in
                            HStack(alignment: .top, spacing: AppTheme.Spacing.small) {
                                Text("•")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Text(characteristic)
                                    .font(.custom("Noteworthy-Bold", size: 16))
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(volcanoType.color.opacity(0.2))
                    )
                    
                    // Example location
                    HStack(spacing: AppTheme.Spacing.small) {
                        Text("📍")
                            .font(.system(size: 20))
                        Text("Example: \(volcanoType.example)")
                            .font(.custom("Noteworthy-Bold", size: 17))
                            .foregroundColor(.yellow)
                            .italic()
                    }
                    .padding(AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(Color.black.opacity(0.2))
                    )
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
                            volcanoType.color.opacity(0.4),
                            volcanoType.color.opacity(0.2),
                            Color.black.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: volcanoType.color.opacity(0.5), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(
                    LinearGradient(
                        colors: [volcanoType.color, volcanoType.color.opacity(0.3)],
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

