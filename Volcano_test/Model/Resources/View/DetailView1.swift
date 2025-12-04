import SwiftUI
import RealityKit
import SceneKit

struct DetailView1: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var historyViewModel = EarthHistoryViewModel()
    @StateObject private var detailViewModel: DetailView1ViewModel
    @StateObject private var quizViewModel: EarthHistoryQuizViewModel
    @State private var showModelView = false
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    init(viewModel: PageViewModel, pageId: Int) {
        self.viewModel = viewModel
        self.pageId = pageId
        _detailViewModel = StateObject(wrappedValue: DetailView1ViewModel(pageViewModel: viewModel, pageId: pageId))
        let historyVM = EarthHistoryViewModel()
        _historyViewModel = StateObject(wrappedValue: historyVM)
        _quizViewModel = StateObject(wrappedValue: EarthHistoryQuizViewModel(historyViewModel: historyVM))
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
                // Header (only show when in educational section)
                if detailViewModel.currentSection == 0 {
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
                    .padding()
                }
                
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
        .sheet(isPresented: $showModelView) {
            ModelView()
        }
        .onChange(of: historyViewModel.currentStep) { newStep in
            // Restore answer for this step if it exists
            if let savedAnswer = historyViewModel.stepAnswers[newStep] {
                historyViewModel.currentQuizAnswer = savedAnswer
                historyViewModel.showQuizResult = true
                historyViewModel.isQuizCorrect = historyViewModel.stepQuizResults[newStep] ?? false
            } else {
                historyViewModel.resetQuizState()
            }
            // Mark page as completed when user reaches the last step
            if historyViewModel.isLastStep {
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
    
    // MARK: - Educational Section
    private var educationalSection: some View {
        VStack(spacing: 0) {
            // Step indicator - centered
            HStack {
                Spacer()
                Text("Step \(historyViewModel.currentStep + 1) of \(historyViewModel.totalSteps)")
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
            
            // Progress dots - green for completed steps
            HStack(spacing: 8) {
                ForEach(0..<historyViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= historyViewModel.currentStep ?
                              Color.green :
                              Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == historyViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: historyViewModel.currentStep)
                    }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $historyViewModel.currentStep) {
                ForEach(0..<historyViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("History of Earth")
                                .font(.custom("Noteworthy-Bold", size: 38))
                            .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current stage card
                            EarthHistoryCardView(
                                stage: historyViewModel.historyStages[step],
                                stepNumber: step + 1,
                                totalSteps: historyViewModel.totalSteps
                            )
                            .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: historyViewModel.historyStages[step].funFact,
                                    emoji: historyViewModel.historyStages[step].emoji
                                )
            }
                            .padding(.horizontal)
                            
                            // 3D Model button (only on last step)
                            if historyViewModel.isLastStep {
                                Button(action: {
                                    showModelView = true
                                }) {
                                    HStack {
                                        Image(systemName: "cube.box")
                                            .font(.system(size: 24))
                                        Text("See 3D Earth Model")
                                            .font(.custom("Noteworthy-Bold", size: 20))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, AppTheme.Spacing.extraLarge)
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
                                .padding(.horizontal)
                            }
                            
                            // Mini Quiz - different question for each step
                            let currentQuestion = historyViewModel.getQuizQuestion(for: step)
                            MiniQuizBlockView(
                                question: currentQuestion.question,
                                options: currentQuestion.options,
                                correctAnswer: currentQuestion.correctAnswer,
                                selectedAnswer: Binding(
                                    get: { historyViewModel.currentQuizAnswer },
                                    set: { _ in }
                                ),
                                showResult: $historyViewModel.showQuizResult,
                                isCorrect: $historyViewModel.isQuizCorrect,
                                onAnswerSelected: { index in
                                    historyViewModel.checkQuizAnswer(index, for: currentQuestion)
                                }
                            )
                            .padding(.horizontal)
                            
                            // Next button (only show if not last step)
                            if !historyViewModel.isLastStep {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        historyViewModel.nextStep()
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
                    Text("🧠 History Quiz")
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
}

#Preview {
    DetailView1(viewModel: PageViewModel(), pageId: 1)
}
