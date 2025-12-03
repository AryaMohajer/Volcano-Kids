import SwiftUI

/// Interactive flip card for fun facts
struct FlipFactCardView: View {
    let fact: String
    let emoji: String
    @State private var isFlipped = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }) {
            ZStack {
                // Front side
                if !isFlipped {
                    VStack(spacing: AppTheme.Spacing.medium) {
                        Text(emoji)
                            .font(.system(size: 50))
                        Text("Tap to reveal!")
                            .font(.custom("Noteworthy-Bold", size: 18))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(isFlipped ? 0 : 1)
                }
                
                // Back side
                if isFlipped {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Text("💡")
                            .font(.system(size: 30))
                        Text(fact)
                            .font(.custom("Noteworthy-Bold", size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(AppTheme.Spacing.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(
                                LinearGradient(
                                    colors: [Color.yellow.opacity(0.7), Color.orange.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .rotation3DEffect(
                        .degrees(isFlipped ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .opacity(isFlipped ? 1 : 0)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

