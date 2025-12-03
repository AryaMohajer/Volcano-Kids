import SwiftUI

/// Card view for Famous Volcanoes
struct FamousVolcanoCardView: View {
    let volcano: FamousVolcano
    let stepNumber: Int
    let totalSteps: Int
    @State private var isAnimating = false
    @State private var showFullDescription = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            // Flag and title
            HStack(spacing: AppTheme.Spacing.medium) {
                Text(volcano.flag)
                    .font(.system(size: 80))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(volcano.title)
                        .font(AppTheme.Typography.pageTitleFont)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                    
                    Text(volcano.location)
                        .font(.custom("Noteworthy-Bold", size: 20))
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
            
            // Short description
            Text(volcano.description)
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
                        .fill(volcano.color.opacity(0.8))
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
                        
                        Text(volcano.microStory)
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
                    
                    // Height info
                    HStack(spacing: AppTheme.Spacing.small) {
                        Text("📏")
                            .font(.system(size: 24))
                        Text("Height: \(volcano.height)")
                            .font(.custom("Noteworthy-Bold", size: 18))
                            .foregroundColor(.yellow)
                    }
                    .padding(AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(volcano.color.opacity(0.2))
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
                            volcano.color.opacity(0.4),
                            volcano.color.opacity(0.2),
                            Color.black.opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: volcano.color.opacity(0.5), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                .stroke(
                    LinearGradient(
                        colors: [volcano.color, volcano.color.opacity(0.3)],
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

