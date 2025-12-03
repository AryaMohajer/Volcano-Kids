import SwiftUI

/// Reusable interactive fact card with tap-to-reveal
struct InteractiveFactCardView: View {
    let title: String
    let emoji: String
    let fact: String
    let isRevealed: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(isRevealed ? Color.yellow.opacity(0.3) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(isRevealed ? Color.yellow : Color.white.opacity(0.3), lineWidth: 2)
                    )
                
                if isRevealed {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Text(emoji)
                            .font(.system(size: 40))
                        Text(title)
                            .font(.custom("Noteworthy-Bold", size: 18))
                            .foregroundColor(.white)
                        Text(fact)
                            .font(.custom("Noteworthy-Bold", size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(AppTheme.Spacing.medium)
                    .transition(.scale.combined(with: .opacity))
                } else {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Text(emoji)
                            .font(.system(size: 40))
                        Text("Tap to reveal!")
                            .font(.custom("Noteworthy-Bold", size: 18))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(AppTheme.Spacing.medium)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isRevealed)
    }
}

/// Mini quiz block component
struct MiniQuizBlockView: View {
    let question: String
    let options: [String]
    let correctAnswer: Int
    @Binding var selectedAnswer: Int?
    @Binding var showResult: Bool
    @Binding var isCorrect: Bool
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("🧠 Quick Quiz!")
                .font(.custom("Noteworthy-Bold", size: 22))
                .foregroundColor(.white)
            
            Text(question)
                .font(.custom("Noteworthy-Bold", size: 18))
                .foregroundColor(.white)
                .padding(.bottom, AppTheme.Spacing.small)
            
            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(0..<options.count, id: \.self) { index in
                    QuizOptionButton(
                        option: options[index],
                        index: index,
                        selectedAnswer: selectedAnswer,
                        showResult: showResult,
                        isCorrect: isCorrect,
                        onTap: {
                            onAnswerSelected(index)
                        }
                    )
                    .disabled(selectedAnswer != nil)
                }
            }
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// MARK: - Quiz Option Button (extracted to simplify type-checking)
struct QuizOptionButton: View {
    let option: String
    let index: Int
    let selectedAnswer: Int?
    let showResult: Bool
    let isCorrect: Bool
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        if selectedAnswer == index {
            if showResult && isCorrect {
                return Color.green.opacity(0.3)
            } else if showResult && !isCorrect {
                return Color.red.opacity(0.3)
            } else {
                return Color.white.opacity(0.2)
            }
        } else {
            return Color.white.opacity(0.1)
        }
    }
    
    private var statusIcon: Image? {
        guard selectedAnswer == index else { return nil }
        
        if showResult && isCorrect {
            return Image(systemName: "checkmark.circle.fill")
        } else if showResult && !isCorrect {
            return Image(systemName: "xmark.circle.fill")
        } else {
            return Image(systemName: "circle.fill")
        }
    }
    
    private var iconColor: Color {
        if showResult && isCorrect {
            return .green
        } else if showResult && !isCorrect {
            return .red
        } else {
            return .white.opacity(0.5)
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(option)
                    .font(.custom("Noteworthy-Bold", size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                if let icon = statusIcon {
                    icon
                        .foregroundColor(iconColor)
                }
            }
            .padding(AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                    .fill(backgroundColor)
            )
        }
    }
}

