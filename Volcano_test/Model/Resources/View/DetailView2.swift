import SwiftUI

struct DetailView2: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var introViewModel = VolcanoIntroViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Beautiful gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.0, blue: 0.2),
                    Color(red: 0.3, green: 0.0, blue: 0.1),
                    AppTheme.Colors.primaryBackground,
                    AppTheme.Colors.accent.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                        .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back button (only one)
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
                
                // Educational Section with pagination
                educationalSection
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Educational Section
    private var educationalSection: some View {
        VStack(spacing: 0) {
            // Step indicator - centered
            HStack {
                Spacer()
                Text("Step \(introViewModel.currentStep + 1) of \(introViewModel.totalSteps)")
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.vertical, AppTheme.Spacing.small)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, AppTheme.Spacing.small)
            
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<introViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= introViewModel.currentStep ? Color.yellow : Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == introViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: introViewModel.currentStep)
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $introViewModel.currentStep) {
                ForEach(0..<introViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("What is Volcano?")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current stage card (reusing VolcanoPartCardView style)
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text(introViewModel.introStages[step].emoji)
                                    .font(.system(size: 100))
                                
                                Text(introViewModel.introStages[step].title)
                                    .font(AppTheme.Typography.pageTitleFont)
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                    .shadow(color: .black.opacity(0.5), radius: 5)
                                
                                Text(introViewModel.introStages[step].description)
                                    .font(AppTheme.Typography.bodyFont)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(AppTheme.Spacing.extraLarge)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                introViewModel.introStages[step].color.opacity(0.4),
                                                introViewModel.introStages[step].color.opacity(0.2),
                                                Color.black.opacity(0.3)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: introViewModel.introStages[step].color.opacity(0.5), radius: 20, x: 0, y: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                                    .stroke(
                                        LinearGradient(
                                            colors: [introViewModel.introStages[step].color, introViewModel.introStages[step].color.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                            )
                            .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: introViewModel.introStages[step].funFact,
                                    emoji: introViewModel.introStages[step].emoji
                                )
                            }
                            .padding(.horizontal)
                            
                            // Mini Quiz - different question for each step
                            let currentQuestion = introViewModel.getQuizQuestion(for: step)
                            MiniQuizBlockView(
                                question: currentQuestion.question,
                                options: currentQuestion.options,
                                correctAnswer: currentQuestion.correctAnswer,
                                selectedAnswer: Binding(
                                    get: { introViewModel.currentQuizAnswer },
                                    set: { _ in }
                                ),
                                showResult: $introViewModel.showQuizResult,
                                isCorrect: $introViewModel.isQuizCorrect,
                                onAnswerSelected: { index in
                                    introViewModel.checkQuizAnswer(index, for: currentQuestion)
                                }
                            )
                            .padding(.horizontal)
                            
                            // Navigation buttons
                            HStack(spacing: AppTheme.Spacing.medium) {
                                // Next button (only show if not last step)
                                if !introViewModel.isLastStep {
                                    Spacer()
                                    Button(action: {
                                        introViewModel.nextStep()
                                    }) {
                                        HStack {
                                            Text("Next Adventure")
                                            Image(systemName: "chevron.right")
                                        }
                                        .font(.custom("Noteworthy-Bold", size: 18))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, AppTheme.Spacing.large)
                                        .padding(.vertical, AppTheme.Spacing.medium)
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
                                    }
                                    Spacer()
                                } else {
                                    // Last step - show puzzle games button
                                    Spacer()
                                    NavigationLink(destination: PuzzleListView()) {
                                        HStack {
                                            Image(systemName: "puzzlepiece.fill")
                                            Text("Play Puzzle Games")
                                        }
                                        .font(.custom("Noteworthy-Bold", size: 18))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, AppTheme.Spacing.large)
                                        .padding(.vertical, AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [.purple, .blue],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                        )
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, AppTheme.Spacing.extraLarge)
                        }
                    }
                    .tag(step)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    DetailView2(viewModel: PageViewModel(), pageId: 2)
}
