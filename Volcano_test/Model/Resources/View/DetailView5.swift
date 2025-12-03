import SwiftUI

struct DetailView5: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var famousViewModel = FamousVolcanoesViewModel()
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
                Text("Step \(famousViewModel.currentStep + 1) of \(famousViewModel.totalSteps)")
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
                ForEach(0..<famousViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= famousViewModel.currentStep ? Color.yellow : Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == famousViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: famousViewModel.currentStep)
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $famousViewModel.currentStep) {
                ForEach(0..<famousViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("Famous Volcanoes")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current volcano card
                            FamousVolcanoCardView(
                                volcano: famousViewModel.famousVolcanoes[step],
                                stepNumber: step + 1,
                                totalSteps: famousViewModel.totalSteps
                            )
                            .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: famousViewModel.famousVolcanoes[step].funFact,
                                    emoji: famousViewModel.famousVolcanoes[step].flag
                                )
                            }
                            .padding(.horizontal)
                            
                            // Mini Quiz - different question for each volcano
                            let currentQuestion = famousViewModel.getQuizQuestion(for: step)
                            MiniQuizBlockView(
                                question: currentQuestion.question,
                                options: currentQuestion.options,
                                correctAnswer: currentQuestion.correctAnswer,
                                selectedAnswer: Binding(
                                    get: { famousViewModel.currentQuizAnswer },
                                    set: { _ in }
                                ),
                                showResult: $famousViewModel.showQuizResult,
                                isCorrect: $famousViewModel.isQuizCorrect,
                                onAnswerSelected: { index in
                                    famousViewModel.checkQuizAnswer(index, for: currentQuestion)
                                }
                            )
                            .padding(.horizontal)
                            
                            // Next button (only show if not last step)
                            if !famousViewModel.isLastStep {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        famousViewModel.nextStep()
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
                                }
                                .padding(.horizontal)
                                .padding(.bottom, AppTheme.Spacing.extraLarge)
                            } else {
                                Spacer()
                                    .frame(height: AppTheme.Spacing.extraLarge)
                            }
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
    DetailView5(viewModel: PageViewModel(), pageId: 5)
}
