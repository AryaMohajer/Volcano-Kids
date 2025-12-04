import SwiftUI

/// Volcano Safety Tips Page
struct DetailView6: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var safetyViewModel = SafetyTipsViewModel()
    @StateObject private var detailViewModel: DetailView6ViewModel
    @StateObject private var quizViewModel: SafetyTipsQuizViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    init(viewModel: PageViewModel, pageId: Int) {
        self.viewModel = viewModel
        self.pageId = pageId
        _detailViewModel = StateObject(wrappedValue: DetailView6ViewModel(pageViewModel: viewModel, pageId: pageId))
        let safetyVM = SafetyTipsViewModel()
        _safetyViewModel = StateObject(wrappedValue: safetyVM)
        _quizViewModel = StateObject(wrappedValue: SafetyTipsQuizViewModel(safetyViewModel: safetyVM))
    }
    
    var body: some View {
        ZStack {
            // Dynamic gradient background based on selected theme
            LinearGradient(
                gradient: Gradient(colors: themeManager.themeColors.backgroundGradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
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
                    
                    // Section toggle
                    if detailViewModel.currentSection == 0 {
                        Button(action: {
                            detailViewModel.switchToQuiz()
                        }) {
                            HStack {
                                Text("Take Quiz")
                                    .font(.custom("Noteworthy-Bold", size: 18))
                                Image(systemName: "brain.head.profile")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.purple.opacity(0.7))
                            )
                        }
                    }
                }
                .padding()
                
                if detailViewModel.currentSection == 0 {
                    // Educational Section
                    educationalSection
                } else {
                    // Quiz Section
                    quizSection
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: safetyViewModel.currentStep) { newStep in
            // Reset quiz state when step changes
            safetyViewModel.resetQuizState()
            // Mark page as completed when user reaches the last step
            if safetyViewModel.isLastStep {
                viewModel.completePage(pageId)
            }
        }
        .onChange(of: quizViewModel.allQuestionsCorrect) { isComplete in
            // Also mark as completed if quiz is completed successfully
            if isComplete {
                viewModel.completePage(pageId)
            }
        }
    }
    
    // MARK: - Quiz Section
    private var quizSection: some View {
        VStack(spacing: 0) {
            // Header with back button
            HStack {
                Button(action: {
                    detailViewModel.switchToEducational()
                    quizViewModel.resetQuiz()
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
            
            ScrollView {
                VStack(spacing: 25) {
                    // Quiz header
                    Text("🧠 Safety Quiz")
                        .font(.custom("Noteworthy-Bold", size: 42))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)
                        .padding(.top, 10)
                    
                    // Progress indicator
                    VStack(spacing: 10) {
                        Text("Question \(quizViewModel.currentQuestionIndex + 1) of \(quizViewModel.totalQuestions)")
                            .font(.custom("Noteworthy-Bold", size: 20))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 20)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .yellow, .orange],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * CGFloat(quizViewModel.progress), height: 20)
                            }
                        }
                        .frame(height: 20)
                        .padding(.horizontal)
                    }
                    .padding()
                    
                    // Current score display
                    if quizViewModel.quizScore > 0 {
                        Text("Score: \(quizViewModel.quizScore)")
                            .font(.custom("Noteworthy-Bold", size: 24))
                            .foregroundColor(.green)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.black.opacity(0.3))
                            )
                    }
                    
                    if !quizViewModel.showQuizResults {
                        // Show current question one at a time
                        if let currentQuestion = quizViewModel.currentQuestion {
                            SingleQuestionView(
                                question: currentQuestion,
                                questionNumber: quizViewModel.currentQuestionIndex + 1,
                                totalQuestions: quizViewModel.totalQuestions,
                                selectedAnswer: quizViewModel.currentQuestionIndex < quizViewModel.quizAnswers.count ? quizViewModel.quizAnswers[quizViewModel.currentQuestionIndex] : nil,
                                onAnswerSelected: { answerIndex in
                                    quizViewModel.handleAnswer(answerIndex)
                                    if quizViewModel.allQuestionsCorrect {
                                        detailViewModel.unlockNextPage()
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    } else {
                        // Show results
                        if quizViewModel.allQuestionsCorrect {
                            // Success - all questions answered correctly
                            SuccessResultsView(
                                score: quizViewModel.lastScore,
                                total: quizViewModel.totalQuestions,
                                onBack: {
                                    detailViewModel.switchToEducational()
                                    quizViewModel.resetQuiz()
                                }
                            )
                            .padding()
                        } else {
                            // Wrong answer - show score and options
                            WrongAnswerResultsView(
                                score: quizViewModel.lastScore,
                                total: quizViewModel.totalQuestions,
                                onRestart: {
                                    quizViewModel.resetQuiz()
                                },
                                onContinue: {
                                    quizViewModel.continueToNextQuestion()
                                }
                            )
                            .padding()
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Educational Section (Redesigned to match Parts of Volcano)
    private var educationalSection: some View {
        VStack(spacing: 0) {
            // Step indicator - centered
            HStack {
                Spacer()
                Text("Step \(safetyViewModel.currentStep + 1) of \(safetyViewModel.safetyTips.count)")
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
                ForEach(0..<safetyViewModel.safetyTips.count, id: \.self) { index in
                    Circle()
                        .fill(index <= safetyViewModel.currentStep ?
                              Color.green :
                              Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == safetyViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: safetyViewModel.currentStep)
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $safetyViewModel.currentStep) {
                ForEach(0..<safetyViewModel.safetyTips.count, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("Volcano Safety Tips")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current tip card (using VolcanoPartCardView style)
                            SafetyTipCardView(tip: safetyViewModel.safetyTips[step], viewModel: safetyViewModel)
                                .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: safetyViewModel.safetyTips[step].funFact,
                                    emoji: safetyViewModel.safetyTips[step].emoji
                                )
                            }
                            .padding(.horizontal)
                            
                            // Mini Quiz - different question for each step
                            let currentQuestion = safetyViewModel.getQuizQuestion(for: step)
                            MiniQuizBlockView(
                                question: currentQuestion.question,
                                options: currentQuestion.options,
                                correctAnswer: currentQuestion.correctAnswer,
                                selectedAnswer: Binding(
                                    get: { safetyViewModel.currentQuizAnswer },
                                    set: { _ in }
                                ),
                                showResult: $safetyViewModel.showQuizResult,
                                isCorrect: $safetyViewModel.isQuizCorrect,
                                onAnswerSelected: { index in
                                    safetyViewModel.checkQuizAnswer(index, for: currentQuestion)
                                }
                            )
                            .padding(.horizontal)
                            
                            // Next button (only show if not last step)
                            if step < safetyViewModel.safetyTips.count - 1 {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        safetyViewModel.nextStep()
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

// MARK: - Main Story Card
struct MainStoryCard: View {
    let emoji: String
    let title: String
    let story: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Text(emoji)
                .font(.system(size: 80))
            
            Text(title)
                .font(.custom("Noteworthy-Bold", size: 28))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .multilineTextAlignment(.center)
            
            Text(story)
                .font(.custom("Noteworthy-Bold", size: 18))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(AppTheme.Spacing.extraLarge)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.2), Color.red.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

// MARK: - Safety Tip Section
struct SafetyTipSection: View {
    let tip: SafetyTip
    @ObservedObject var viewModel: SafetyTipsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            HStack(spacing: AppTheme.Spacing.medium) {
                Image(systemName: tip.icon)
                    .font(.system(size: 30))
                    .foregroundColor(AppTheme.Colors.accent)
                
                Text(tip.title)
                    .font(.custom("Noteworthy-Bold", size: 22))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
            
            Text(tip.description)
                .font(.custom("Noteworthy-Bold", size: 17))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .fixedSize(horizontal: false, vertical: true)
            
            // Micro story box
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                HStack {
                    Text("📖")
                        .font(.system(size: 20))
                    Text("Story Time!")
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
                
                Text(tip.microStory)
                    .font(.custom("Noteworthy-Bold", size: 15))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(Color.orange.opacity(0.1))
            )
            
            // Interactive fact card
            InteractiveFactCardView(
                title: "Did You Know?",
                emoji: "💡",
                fact: tip.funFact,
                isRevealed: viewModel.revealedFacts.contains(tip.id),
                onTap: {
                    viewModel.toggleFactReveal(tip.id)
                }
            )
        }
        .padding(AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Safety Gear Checklist Item
struct SafetyGearChecklistItem: View {
    let gear: SafetyGearItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.medium) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.green : Color.gray.opacity(0.2))
                        .frame(width: 30, height: 30)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                
                Text(gear.emoji)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(gear.name)
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text(gear.description)
                        .font(.custom("Noteworthy-Bold", size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                
                Spacer()
            }
            .padding(AppTheme.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(isSelected ? Color.green.opacity(0.1) : Color.gray.opacity(0.05))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

#Preview {
    DetailView6(viewModel: PageViewModel(), pageId: 6)
}

