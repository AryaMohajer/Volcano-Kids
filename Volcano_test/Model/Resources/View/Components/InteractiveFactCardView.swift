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
                        correctAnswerIndex: correctAnswer,
                        onTap: {
                            onAnswerSelected(index)
                        }
                    )
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
    let correctAnswerIndex: Int
    let onTap: () -> Void
    
    @State private var iconScale: CGFloat = 1.0
    
    private var isSelected: Bool {
        selectedAnswer == index
    }
    
    private var isCorrectOption: Bool {
        index == correctAnswerIndex
    }
    
    private var backgroundColor: Color {
        if showResult {
            if isCorrectOption {
                return Color.green.opacity(0.4)
            } else if isSelected && !isCorrect {
                return Color.red.opacity(0.4)
            } else {
                return Color.white.opacity(0.1)
            }
        } else if isSelected {
            return Color.white.opacity(0.2)
        } else {
            return Color.white.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        if showResult {
            if isCorrectOption {
                return Color.green
            } else if isSelected && !isCorrect {
                return Color.red
            } else {
                return Color.clear
            }
        } else if isSelected {
            return Color.white.opacity(0.5)
        } else {
            return Color.clear
        }
    }
    
    private var statusIcon: Image? {
        if showResult {
            if isCorrectOption {
                return Image(systemName: "checkmark.circle.fill")
            } else if isSelected && !isCorrect {
                return Image(systemName: "xmark.circle.fill")
            }
        } else if isSelected {
            return Image(systemName: "circle.fill")
        }
        return nil
    }
    
    private var iconColor: Color {
        if showResult {
            if isCorrectOption {
                return .green
            } else if isSelected && !isCorrect {
                return .red
            }
        }
        return .white.opacity(0.5)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.medium) {
                // Status icon on the left - larger and more prominent
                if let icon = statusIcon {
                    icon
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(iconColor)
                        .scaleEffect(iconScale)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: iconScale)
                } else if showResult && isCorrectOption {
                    // Show checkmark even if not selected (correct answer indicator)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                        .scaleEffect(iconScale)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: iconScale)
                } else {
                    // Placeholder to maintain spacing
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 32, height: 32)
                }
                
                Text(option)
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Additional visual indicator on the right for extra clarity
                if showResult && isCorrectOption {
                    Text("✓ CORRECT")
                        .font(.custom("Noteworthy-Bold", size: 16))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.2))
                        )
                } else if showResult && isSelected && !isCorrect {
                    Text("✗ WRONG")
                        .font(.custom("Noteworthy-Bold", size: 16))
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.2))
                        )
                }
            }
            .padding(AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(borderColor, lineWidth: 3)
                    )
            )
            .shadow(
                color: showResult && (isCorrectOption || (isSelected && !isCorrect)) ? 
                    (isCorrectOption ? Color.green.opacity(0.6) : Color.red.opacity(0.6)) : 
                    Color.clear,
                radius: showResult ? 10 : 0
            )
        }
        .disabled(selectedAnswer != nil)
        .onAppear {
            if showResult && (isSelected || isCorrectOption) {
                iconScale = 1.3
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        iconScale = 1.0
                    }
                }
            }
        }
        .onChange(of: showResult) { newValue in
            if newValue && (isSelected || isCorrectOption) {
                iconScale = 1.3
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        iconScale = 1.0
                    }
                }
            }
        }
    }
}

