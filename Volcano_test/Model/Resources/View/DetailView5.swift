import SwiftUI

struct DetailView5: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var famousViewModel = FamousVolcanoesViewModel()
    @StateObject private var detailViewModel: DetailView5ViewModel
    @StateObject private var quizViewModel: FamousVolcanoesQuizViewModel
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var themeManager = ThemeManager.shared
    
    init(viewModel: PageViewModel, pageId: Int) {
        self.viewModel = viewModel
        self.pageId = pageId
        _detailViewModel = StateObject(wrappedValue: DetailView5ViewModel(pageViewModel: viewModel, pageId: pageId))
        let famousVM = FamousVolcanoesViewModel()
        _famousViewModel = StateObject(wrappedValue: famousVM)
        _quizViewModel = StateObject(wrappedValue: FamousVolcanoesQuizViewModel(famousViewModel: famousVM))
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
        .navigationBarBackButtonHidden(true)
        .onChange(of: famousViewModel.currentStep) { newStep in
            // Reset quiz state when step changes
            famousViewModel.resetQuizState()
            // Mark page as completed when user reaches the last step
            if famousViewModel.isLastStep {
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
                    Text("🧠 Famous Volcanoes Quiz")
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
                        .fill(index <= famousViewModel.currentStep ?
                              Color.green :
                              Color.white.opacity(0.3))
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
