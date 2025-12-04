import SwiftUI

struct DetailView3: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var detailViewModel: DetailView3ViewModel
    @StateObject private var partsViewModel = VolcanoPartsViewModel()
    @StateObject private var quizViewModel = VolcanoPartsQuizViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: PageViewModel, pageId: Int) {
        self.viewModel = viewModel
        self.pageId = pageId
        _detailViewModel = StateObject(wrappedValue: DetailView3ViewModel(pageViewModel: viewModel, pageId: pageId))
    }
    
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
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue.opacity(0.7))
                        )
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
    }
    
    // MARK: - Educational Section (Redesigned)
    private var educationalSection: some View {
                                VStack(spacing: 0) {
            // Step indicator - centered
            HStack {
                Spacer()
                Text("Step \(partsViewModel.currentStep + 1) of \(partsViewModel.totalSteps)")
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
                ForEach(0..<partsViewModel.totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index <= partsViewModel.currentStep ? Color.yellow : Color.white.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .scaleEffect(index == partsViewModel.currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3), value: partsViewModel.currentStep)
                                        }
                                    }
            .padding(.vertical, AppTheme.Spacing.small)
            
            // Main content area with pagination
            TabView(selection: $partsViewModel.currentStep) {
                ForEach(0..<partsViewModel.totalSteps, id: \.self) { step in
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.large) {
                            // Title
                            Text("Parts of a Volcano")
                                .font(.custom("Noteworthy-Bold", size: 38))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                                .padding(.top, AppTheme.Spacing.medium)
                            
                            // Current part card
                            VolcanoPartCardView(
                                part: partsViewModel.volcanoParts[step],
                                stepNumber: step + 1,
                                totalSteps: partsViewModel.totalSteps
                            )
                            .padding(.horizontal)
                            
                            // Fun fact flip card
                            VStack(spacing: AppTheme.Spacing.medium) {
                                Text("💡 Fun Fact!")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                                    .foregroundColor(.yellow)
                                
                                FlipFactCardView(
                                    fact: partsViewModel.volcanoParts[step].funFact,
                                    emoji: partsViewModel.volcanoParts[step].emoji
                                )
                            }
                            .padding(.horizontal)
                            
                            // Animated lava (only for Lava Flow step)
                            if partsViewModel.volcanoParts[step].name == "Lava Flow" {
                                VStack {
                                    Text("Watch the lava flow! 🌊")
                                        .font(.custom("Noteworthy-Bold", size: 20))
                                    .foregroundColor(.white)
                                    AnimatedLavaView()
                                        .padding()
                            }
                                .padding(.horizontal)
                            }
                            
                            // Next button (only show if not last step)
                            if !partsViewModel.isLastStep {
                                HStack {
                                    Spacer()
                                Button(action: {
                                        partsViewModel.nextStep()
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
                                // Last step - just add spacing, no buttons or text
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
            // Header with back button (only one)
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
                    Text("🧠 Volcano Quiz")
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
                            .foregroundColor(.yellow)
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
                            // Wrong answer - show score and restart option
                            WrongAnswerResultsView(
                                score: quizViewModel.lastScore,
                                total: quizViewModel.totalQuestions,
                                onRestart: {
                                    quizViewModel.resetQuiz()
                                },
                                onBack: {
                                    detailViewModel.switchToEducational()
                                    quizViewModel.resetQuiz()
                                }
                            )
                            .padding()
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Wrong Answer! ❌", isPresented: $quizViewModel.showWrongAnswerAlert) {
            Button("OK") { }
        } message: {
            Text("That's not quite right. Let's start over from the beginning!")
        }
    }
}


// MARK: - Single Question View
struct SingleQuestionView: View {
    let question: QuizQuestion
    let questionNumber: Int
    let totalQuestions: Int
    let selectedAnswer: Int?
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question.question)
                .font(.custom("Noteworthy-Bold", size: 24))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 15) {
                ForEach(0..<question.options.count, id: \.self) { optionIndex in
                    Button(action: {
                        onAnswerSelected(optionIndex)
                    }) {
                        HStack {
                            Text(question.options[optionIndex])
                                .font(.custom("Noteworthy-Bold", size: 20))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if selectedAnswer == optionIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    selectedAnswer == optionIndex ?
                                        Color.green.opacity(0.4) as Color :
                                        Color(white: 1, opacity: 0.2)
                                )
                        )
                    }
                    .disabled(selectedAnswer != nil) // Disable after selection
                }
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.5) as Color, Color.blue.opacity(0.5) as Color],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 15)
        )
    }
}

// MARK: - Wrong Answer Results View
struct WrongAnswerResultsView: View {
    let score: Int
    let total: Int
    let onRestart: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            // Result display
            VStack(spacing: 15) {
                Text("❌ Wrong Answer!")
                    .font(.custom("Noteworthy-Bold", size: 36))
                    .foregroundColor(.red)
                
                Text("You got \(score) questions correct!")
                    .font(.custom("Noteworthy-Bold", size: 24))
                    .foregroundColor(.white)
                
                // Score circle
        ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 15)
                        .frame(width: 150, height: 150)
                    
                Circle()
                        .trim(from: 0, to: CGFloat(score) / CGFloat(total))
                        .stroke(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(score)/\(total)")
                        .font(.custom("Noteworthy-Bold", size: 32))
                        .foregroundColor(.white)
                }
                
                Text("Let's start over and try again! 💪")
                    .font(.custom("Noteworthy-Bold", size: 20))
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(white: 0, opacity: 0.3))
                    .shadow(radius: 15)
            )
            
            // Action buttons
            HStack(spacing: 20) {
                Button(action: onRestart) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Try Again")
                    }
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.orange.opacity(0.7))
                    )
                }
                
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("Review")
        }
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.7))
                    )
                }
            }
        }
    }
}

// MARK: - Success Results View
struct SuccessResultsView: View {
    let score: Int
    let total: Int
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            // Success display
            VStack(spacing: 15) {
                Text("🎉 Amazing! 🎉")
                    .font(.custom("Noteworthy-Bold", size: 42))
                    .foregroundColor(.yellow)
                
                Text("You answered all \(total) questions correctly!")
                    .font(.custom("Noteworthy-Bold", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Score circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 15)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0, to: 1.0)
                        .stroke(
                            LinearGradient(
                                colors: [.green, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(score)/\(total)")
                        .font(.custom("Noteworthy-Bold", size: 32))
                        .foregroundColor(.white)
                }
                
                Text("You're a Volcano Expert! 🌋")
                    .font(.custom("Noteworthy-Bold", size: 22))
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(white: 0, opacity: 0.3))
                    .shadow(radius: 15)
            )
            
            // Back button
            Button(action: onBack) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Continue Learning")
                }
                .font(.custom("Noteworthy-Bold", size: 20))
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green.opacity(0.7))
                )
    }
        }
    }
}

// MARK: - Quiz Results View
struct QuizResultsView: View {
    let score: Int
    let total: Int
    let questions: [QuizQuestion]
    let answers: [Int]
    let onRetry: () -> Void
    let onBack: () -> Void
    
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 25) {
            // Score display
            VStack(spacing: 15) {
                Text(score >= 4 ? "🎉 Excellent!" : score >= 3 ? "👍 Good Job!" : "💪 Keep Learning!")
                    .font(.custom("Noteworthy-Bold", size: 36))
                    .foregroundColor(.white)
                
                Text("You got \(score) out of \(total) correct!")
                    .font(.custom("Noteworthy-Bold", size: 24))
                    .foregroundColor(.white)
                
                // Score circle
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 15)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(score) / CGFloat(total))
                        .stroke(
                            LinearGradient(
                                colors: [.green, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(score)/\(total)")
                        .font(.custom("Noteworthy-Bold", size: 32))
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(white: 0, opacity: 0.3))
                    .shadow(radius: 15)
            )
            
            // Action buttons
            HStack(spacing: 20) {
                Button(action: onRetry) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Try Again")
                    }
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.7))
                    )
                }
                
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("Review")
                    }
                    .font(.custom("Noteworthy-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.purple.opacity(0.7))
                    )
                }
            }
        }
    }
}

#Preview {
    DetailView3(viewModel: PageViewModel(), pageId: 3)
}

