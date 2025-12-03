import SwiftUI

struct DetailView3: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @StateObject private var partsViewModel = VolcanoPartsViewModel()
    @State private var currentSection: Int = 0 // 0 = educational, 1 = quiz
    @State private var currentQuestionIndex = 0
    @State private var quizAnswers: [Int] = []
    @State private var showQuizResults = false
    @State private var quizScore = 0
    @State private var showWrongAnswerAlert = false
    @State private var lastScore = 0
    @Environment(\.presentationMode) var presentationMode
    
    // Quiz questions - 30 questions
    let quizQuestions: [QuizQuestion] = [
        QuizQuestion(question: "What is the opening at the top of a volcano called?", options: ["Crater", "Vent", "Magma Chamber", "Lava Flow"], correctAnswer: 0),
        QuizQuestion(question: "Where does magma wait before erupting?", options: ["Crater", "Vent", "Magma Chamber", "Ash Cloud"], correctAnswer: 2),
        QuizQuestion(question: "What shoots high into the sky during an eruption?", options: ["Lava", "Magma", "Ash Cloud", "Rocks"], correctAnswer: 2),
        QuizQuestion(question: "What flows down the mountain like a hot river?", options: ["Magma", "Lava Flow", "Ash", "Steam"], correctAnswer: 1),
        QuizQuestion(question: "What is the tunnel that helps magma escape?", options: ["Crater", "Vent", "Chamber", "Flow"], correctAnswer: 1),
        QuizQuestion(question: "What is hot, melted rock called when it's inside the volcano?", options: ["Lava", "Magma", "Ash", "Steam"], correctAnswer: 1),
        QuizQuestion(question: "What is hot, melted rock called when it comes out of the volcano?", options: ["Magma", "Lava", "Ash", "Rocks"], correctAnswer: 1),
        QuizQuestion(question: "Which part of a volcano is at the very top?", options: ["Vent", "Crater", "Magma Chamber", "Base"], correctAnswer: 1),
        QuizQuestion(question: "What happens when a volcano erupts?", options: ["It rains", "Lava and ash come out", "It gets cold", "Nothing"], correctAnswer: 1),
        QuizQuestion(question: "What color is hot lava?", options: ["Blue", "Green", "Red and orange", "Yellow"], correctAnswer: 2),
        QuizQuestion(question: "How hot can lava get?", options: ["100°C", "500°C", "1,200°C", "2,000°C"], correctAnswer: 2),
        QuizQuestion(question: "What is the name for tiny pieces of rock that shoot from a volcano?", options: ["Lava", "Magma", "Ash", "Steam"], correctAnswer: 2),
        QuizQuestion(question: "Where is the magma chamber located?", options: ["At the top", "On the side", "Deep underground", "In the sky"], correctAnswer: 2),
        QuizQuestion(question: "What shape is a volcano usually?", options: ["Square", "Round like a cone", "Triangle", "Rectangle"], correctAnswer: 1),
        QuizQuestion(question: "Can volcanoes be found underwater?", options: ["No", "Yes, they can!", "Only in movies", "Maybe"], correctAnswer: 1),
        QuizQuestion(question: "What do we call a volcano that might erupt again?", options: ["Dead", "Sleeping", "Active", "Old"], correctAnswer: 2),
        QuizQuestion(question: "What do we call a volcano that hasn't erupted in a long time?", options: ["Active", "Dormant", "Extinct", "Sleeping"], correctAnswer: 1),
        QuizQuestion(question: "Which volcano part is like a tunnel?", options: ["Crater", "Vent", "Magma Chamber", "Lava Flow"], correctAnswer: 1),
        QuizQuestion(question: "What comes out of the crater during an eruption?", options: ["Water", "Lava and ash", "Snow", "Wind"], correctAnswer: 1),
        QuizQuestion(question: "What is the biggest part of a volcano?", options: ["The crater", "The vent", "The magma chamber", "The ash cloud"], correctAnswer: 2),
        QuizQuestion(question: "How fast can lava flow?", options: ["As slow as walking", "As fast as a car", "As fast as a plane", "It doesn't move"], correctAnswer: 1),
        QuizQuestion(question: "What happens to lava when it cools down?", options: ["It disappears", "It turns into rock", "It turns into water", "It turns into air"], correctAnswer: 1),
        QuizQuestion(question: "What is the dark cloud that comes from a volcano?", options: ["Rain cloud", "Ash cloud", "Snow cloud", "Wind cloud"], correctAnswer: 1),
        QuizQuestion(question: "Can ash clouds travel far away?", options: ["No, they stay close", "Yes, all around the world!", "Only a few miles", "They don't move"], correctAnswer: 1),
        QuizQuestion(question: "What is the bottom part of a volcano called?", options: ["Top", "Base", "Middle", "Side"], correctAnswer: 1),
        QuizQuestion(question: "What do volcanoes create when they erupt underwater?", options: ["Bubbles", "New islands", "Fish", "Coral"], correctAnswer: 1),
        QuizQuestion(question: "What is the hottest part of a volcano?", options: ["The top", "The magma chamber", "The outside", "The base"], correctAnswer: 1),
        QuizQuestion(question: "How many active volcanoes are there in the world?", options: ["About 100", "About 500", "About 1,500", "About 5,000"], correctAnswer: 2),
        QuizQuestion(question: "What do we call the path lava takes down the mountain?", options: ["Lava trail", "Lava flow", "Lava path", "Lava road"], correctAnswer: 1),
        QuizQuestion(question: "What makes a volcano erupt?", options: ["Rain", "Wind", "Pressure from hot magma", "Cold weather"], correctAnswer: 2)
    ]
    
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
                    if currentSection == 0 {
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                currentSection = 1
                            }
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
                
                if currentSection == 0 {
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
            // Step indicator
            HStack {
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
                            
                            // Navigation buttons
                            HStack(spacing: AppTheme.Spacing.medium) {
                                // Previous button
                                if !partsViewModel.isFirstStep {
                                    Button(action: {
                                        partsViewModel.previousStep()
                                    }) {
                                        HStack {
                                            Image(systemName: "chevron.left")
                                            Text("Previous")
                                        }
                                        .font(.custom("Noteworthy-Bold", size: 18))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, AppTheme.Spacing.large)
                                        .padding(.vertical, AppTheme.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                                .fill(Color.blue.opacity(0.7))
                                        )
                                    }
                                }
                                
                                Spacer()
                                
                                // Next button
                                if !partsViewModel.isLastStep {
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
                                } else {
                                    // Last step - show quiz prompt
                                    VStack(spacing: AppTheme.Spacing.medium) {
                                        Text("🎉 You've learned all the parts! 🎉")
                                            .font(.custom("Noteworthy-Bold", size: 22))
                                            .foregroundColor(.yellow)
                                            .multilineTextAlignment(.center)
                                        
                                        Button(action: {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                                currentSection = 1
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: "brain.head.profile")
                                                    .font(.system(size: 24))
                                                Text("Take Quiz")
                                                    .font(.custom("Noteworthy-Bold", size: 22))
                                            }
                                            .foregroundColor(.white)
                                            .padding(.horizontal, AppTheme.Spacing.extraLarge)
                                            .padding(.vertical, AppTheme.Spacing.medium)
                                            .background(
                                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [.purple, .blue],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .shadow(color: .purple, radius: 15)
                                            )
                                        }
                                    }
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
    
    // MARK: - Quiz Section
    private var quizSection: some View {
        VStack(spacing: 0) {
            // Header with back button
            HStack {
                Button(action: {
                    withAnimation {
                        currentSection = 0
                        resetQuiz()
                    }
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
            }
            .padding()
            
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
                        Text("Question \(currentQuestionIndex + 1) of \(quizQuestions.count)")
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
                                    .frame(width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(quizQuestions.count), height: 20)
                            }
                        }
                        .frame(height: 20)
                        .padding(.horizontal)
                    }
                    .padding()
                    
                    // Current score display
                    if quizScore > 0 {
                        Text("Score: \(quizScore)")
                            .font(.custom("Noteworthy-Bold", size: 24))
                            .foregroundColor(.yellow)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.black.opacity(0.3))
                            )
                    }
                    
                    if !showQuizResults {
                        // Show current question one at a time
                        if currentQuestionIndex < quizQuestions.count {
                            SingleQuestionView(
                                question: quizQuestions[currentQuestionIndex],
                                questionNumber: currentQuestionIndex + 1,
                                totalQuestions: quizQuestions.count,
                                selectedAnswer: currentQuestionIndex < quizAnswers.count ? quizAnswers[currentQuestionIndex] : nil,
                                onAnswerSelected: { answerIndex in
                                    handleAnswer(answerIndex)
                                }
                            )
                            .padding(.horizontal)
                        }
                    } else {
                        // Show results
                        if lastScore == quizQuestions.count {
                            // Success - all questions answered correctly
                            SuccessResultsView(
                                score: lastScore,
                                total: quizQuestions.count,
                                onBack: {
                                    withAnimation {
                                        currentSection = 0
                                        resetQuiz()
                                    }
                                }
                            )
                            .padding()
                        } else {
                            // Wrong answer - show score and restart option
                            WrongAnswerResultsView(
                                score: lastScore,
                                total: quizQuestions.count,
                                onRestart: {
                                    resetQuiz()
                                    showQuizResults = false
                                },
                                onBack: {
                                    withAnimation {
                                        currentSection = 0
                                        resetQuiz()
                                    }
                                }
                            )
                            .padding()
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Wrong Answer! ❌", isPresented: $showWrongAnswerAlert) {
            Button("OK") { }
        } message: {
            Text("That's not quite right. Let's start over from the beginning!")
        }
    }
    
    private func handleAnswer(_ answerIndex: Int) {
        let currentQuestion = quizQuestions[currentQuestionIndex]
        let isCorrect = answerIndex == currentQuestion.correctAnswer
        
        // Store answer
        if currentQuestionIndex < quizAnswers.count {
            quizAnswers[currentQuestionIndex] = answerIndex
        } else {
            quizAnswers.append(answerIndex)
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        
        if isCorrect {
            // Correct answer - move to next question
            generator.notificationOccurred(.success)
            quizScore += 1
            
            // Move to next question
            if currentQuestionIndex < quizQuestions.count - 1 {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    currentQuestionIndex += 1
                }
            } else {
                // Completed all questions successfully!
                lastScore = quizScore
                withAnimation {
                    showQuizResults = true
                }
                takeALookAndUnlockNextPage()
            }
        } else {
            // Wrong answer - restart from first question
            generator.notificationOccurred(.error)
            lastScore = quizScore
            
            // Show wrong answer alert and results immediately
            showWrongAnswerAlert = true
            showQuizResults = true
        }
    }
    
    private func resetQuiz() {
        currentQuestionIndex = 0
        quizAnswers = []
        quizScore = 0
    }
    
    
    private func takeALookAndUnlockNextPage() {
        if let nextIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < viewModel.pages.count {
                viewModel.unlockPage(viewModel.pages[nextPageIndex].id)
            }
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

// MARK: - Supporting Types
struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

#Preview {
    DetailView3(viewModel: PageViewModel(), pageId: 3)
}

