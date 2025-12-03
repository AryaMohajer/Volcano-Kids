import SwiftUI

struct DetailView3: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @State private var currentSection: Int = 0 // 0 = educational, 1 = quiz
    @State private var quizAnswers: [Int] = []
    @State private var showQuizResults = false
    @State private var quizScore = 0
    @Environment(\.presentationMode) var presentationMode
    
    // Educational content - volcano parts
    let volcanoParts: [VolcanoPartInfo] = [
        VolcanoPartInfo(
            name: "Crater",
            emoji: "🌋",
            description: "The crater is the big opening at the very top of the volcano! It's like a giant bowl where hot lava comes out when the volcano erupts. Think of it as the volcano's mouth!",
            funFact: "Some craters are so big, you could fit a whole city inside them!",
            color: .red
        ),
        VolcanoPartInfo(
            name: "Vent",
            emoji: "🕳️",
            description: "The vent is like a tunnel inside the volcano! It's the pathway that helps hot magma travel from deep underground all the way up to the crater. It's the volcano's secret passage!",
            funFact: "The vent can be very narrow or super wide, depending on the volcano!",
            color: .orange
        ),
        VolcanoPartInfo(
            name: "Magma Chamber",
            emoji: "🔥",
            description: "Deep, deep underground, there's a special room called the magma chamber. This is where super hot, melted rock called magma waits and gets ready to erupt! It's like the volcano's hidden treasure room!",
            funFact: "The magma chamber can be as big as a whole mountain!",
            color: .yellow
        ),
        VolcanoPartInfo(
            name: "Lava Flow",
            emoji: "🌊",
            description: "When magma comes out of the crater, it becomes lava! Lava flows down the sides of the volcano like a hot, glowing river. It's bright red and orange, and it's super, super hot!",
            funFact: "Lava can flow as fast as a car on a highway!",
            color: .red
        ),
        VolcanoPartInfo(
            name: "Ash Cloud",
            emoji: "☁️",
            description: "When a volcano erupts, it shoots tiny pieces of rock and dust high into the sky! This creates a big, dark cloud called an ash cloud. It's like nature's own fireworks show!",
            funFact: "Ash clouds can travel all around the world in the wind!",
            color: .gray
        )
    ]
    
    // Quiz questions
    let quizQuestions: [QuizQuestion] = [
        QuizQuestion(
            question: "What is the opening at the top of a volcano called?",
            options: ["Crater", "Vent", "Magma Chamber", "Lava Flow"],
            correctAnswer: 0
        ),
        QuizQuestion(
            question: "Where does magma wait before erupting?",
            options: ["Crater", "Vent", "Magma Chamber", "Ash Cloud"],
            correctAnswer: 2
        ),
        QuizQuestion(
            question: "What shoots high into the sky during an eruption?",
            options: ["Lava", "Magma", "Ash Cloud", "Rocks"],
            correctAnswer: 2
        ),
        QuizQuestion(
            question: "What flows down the mountain like a hot river?",
            options: ["Magma", "Lava Flow", "Ash", "Steam"],
            correctAnswer: 1
        ),
        QuizQuestion(
            question: "What is the tunnel that helps magma escape?",
            options: ["Crater", "Vent", "Chamber", "Flow"],
            correctAnswer: 1
        )
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
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 40))
                        .foregroundColor(.white)
                            .shadow(color: .black, radius: 5)
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
    
    // MARK: - Educational Section
    private var educationalSection: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Title
                Text("Parts of a Volcano")
                    .font(.custom("Noteworthy-Bold", size: 42))
                                            .foregroundColor(.white)
                    .shadow(color: .black, radius: 10)
                    .padding(.top, 10)
                                    
                Text("Learn about the amazing parts that make up a volcano! 🌋")
                    .font(.custom("Noteworthy-Bold", size: 20))
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                
                // Volcano parts cards
                ForEach(Array(volcanoParts.enumerated()), id: \.element.id) { index, part in
                    VolcanoPartCard(part: part, index: index)
                        .padding(.horizontal)
                            }
                            
                            // Fun facts section
                FunFactsBox()
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Quiz prompt
                            VStack(spacing: 15) {
                    Text("🧠 Ready to Test Your Knowledge?")
                        .font(.custom("Noteworthy-Bold", size: 24))
                                    .foregroundColor(.white)
                                
                                Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            currentSection = 1
                        }
                                }) {
                                    HStack {
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 24))
                            Text("Start Quiz")
                                .font(.custom("Noteworthy-Bold", size: 22))
                                    }
                                    .foregroundColor(.white)
                        .padding(.horizontal, 30)
                                    .padding(.vertical, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
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
                .padding()
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Quiz Section
    private var quizSection: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Quiz header
                Text("🧠 Volcano Quiz")
                    .font(.custom("Noteworthy-Bold", size: 42))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 10)
                    .padding(.top, 10)
                
                Text("Test what you learned!")
                    .font(.custom("Noteworthy-Bold", size: 20))
                    .foregroundColor(.white.opacity(0.9))
                
                if !showQuizResults {
                    // Quiz questions
                    ForEach(Array(quizQuestions.enumerated()), id: \.offset) { index, question in
                        QuizQuestionCard(
                            question: question,
                            index: index,
                            selectedAnswer: quizAnswers.count > index ? quizAnswers[index] : nil,
                            onAnswerSelected: { answerIndex in
                                if quizAnswers.count <= index {
                                    quizAnswers.append(answerIndex)
                                } else {
                                    quizAnswers[index] = answerIndex
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                    
                    // Submit button
                    if quizAnswers.count == quizQuestions.count {
                        Button(action: {
                            calculateScore()
                            showQuizResults = true
                            
                            // Unlock next page if score is good
                            if quizScore >= 4 {
                                takeALookAndUnlockNextPage()
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Submit Answers")
                                    .font(.custom("Noteworthy-Bold", size: 22))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.green.opacity(0.8))
                                    .shadow(radius: 15)
                            )
                        }
                        .padding()
                    }
                } else {
                    // Results
                    QuizResultsView(
                        score: quizScore,
                        total: quizQuestions.count,
                        questions: quizQuestions,
                        answers: quizAnswers,
                        onRetry: {
                            quizAnswers = []
                            quizScore = 0
                            showQuizResults = false
                        },
                        onBack: {
                            withAnimation {
                                currentSection = 0
                                quizAnswers = []
                                quizScore = 0
                                showQuizResults = false
                            }
                        }
                    )
                    .padding()
                }
            }
            .padding(.bottom, 30)
        }
    }
    
    private func calculateScore() {
        quizScore = 0
        for (index, question) in quizQuestions.enumerated() {
            if index < quizAnswers.count && quizAnswers[index] == question.correctAnswer {
                quizScore += 1
            }
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        if quizScore >= 4 {
            generator.notificationOccurred(.success)
        } else {
            generator.notificationOccurred(.warning)
        }
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

// MARK: - Volcano Part Card
struct VolcanoPartCard: View {
    let part: VolcanoPartInfo
    let index: Int
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                // Emoji
                Text(part.emoji)
                    .font(.system(size: 60))
                    .scaleEffect(appear ? 1.0 : 0.5)
                    .rotationEffect(.degrees(appear ? 0 : -180))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(part.name)
                        .font(.custom("Noteworthy-Bold", size: 28))
                        .foregroundColor(.white)
                    
                    Text(part.description)
                        .font(.custom("Noteworthy-Bold", size: 18))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Fun fact
            HStack {
                Text("💡")
                    .font(.system(size: 20))
                Text(part.funFact)
                    .font(.custom("Noteworthy-Bold", size: 16))
                    .foregroundColor(.yellow)
                    .italic()
            }
            .padding(.horizontal)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            part.color.opacity(0.3) as Color,
                            part.color.opacity(0.2) as Color,
                            Color(white: 0, opacity: 0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: part.color, radius: 15)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [part.color, part.color.opacity(0.3) as Color],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.15)) {
                appear = true
            }
        }
    }
}

// MARK: - Fun Facts Box
struct FunFactsBox: View {
    let facts = [
        "🌡️ Lava can be as hot as 1,200°C - that's hotter than your oven!",
        "🏔️ Some volcanoes are taller than the clouds!",
        "🌍 There are about 1,500 active volcanoes in the world!",
        "⚡ Lightning can happen inside volcanic ash clouds!",
        "🌊 Underwater volcanoes create new islands!"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("🌟 Amazing Volcano Facts! 🌟")
                .font(.custom("Noteworthy-Bold", size: 26))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            
            ForEach(facts, id: \.self) { fact in
                HStack(alignment: .top, spacing: 10) {
                    Text(fact)
                        .font(.custom("Noteworthy-Bold", size: 16))
                        .foregroundColor(.white.opacity(0.95))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(white: 0, opacity: 0.3))
                .shadow(radius: 15)
        )
    }
}

// MARK: - Quiz Question Card
struct QuizQuestionCard: View {
    let question: QuizQuestion
    let index: Int
    let selectedAnswer: Int?
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Question \(index + 1)")
                .font(.custom("Noteworthy-Bold", size: 18))
                .foregroundColor(.yellow)
            
            Text(question.question)
                .font(.custom("Noteworthy-Bold", size: 22))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 12) {
                ForEach(0..<question.options.count, id: \.self) { optionIndex in
                    Button(action: {
                        onAnswerSelected(optionIndex)
                    }) {
                        HStack {
                            Text(question.options[optionIndex])
                                .font(.custom("Noteworthy-Bold", size: 18))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if selectedAnswer == optionIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    selectedAnswer == optionIndex ?
                                        Color.green.opacity(0.3) as Color :
                                        Color(white: 1, opacity: 0.2)
                                )
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.4) as Color, Color.blue.opacity(0.4) as Color],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 10)
        )
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
struct VolcanoPartInfo: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
    let funFact: String
    let color: Color
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

#Preview {
    DetailView3(viewModel: PageViewModel(), pageId: 3)
}
