import SwiftUI
import Foundation

/// ViewModel for managing the Parts of Volcano quiz
class VolcanoPartsQuizViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var quizAnswers: [Int] = []
    @Published var showQuizResults: Bool = false
    @Published var quizScore: Int = 0
    @Published var lastScore: Int = 0
    
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
    
    var totalQuestions: Int {
        quizQuestions.count
    }
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < quizQuestions.count else { return nil }
        return quizQuestions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(totalQuestions)
    }
    
    var isQuizComplete: Bool {
        currentQuestionIndex >= quizQuestions.count
    }
    
    var allQuestionsCorrect: Bool {
        lastScore == quizQuestions.count
    }
    
    func handleAnswer(_ answerIndex: Int) {
        guard let currentQuestion = currentQuestion else { return }
        let isCorrect = answerIndex == currentQuestion.correctAnswer
        
        // Store answer
        if currentQuestionIndex < quizAnswers.count {
            quizAnswers[currentQuestionIndex] = answerIndex
        } else {
            quizAnswers.append(answerIndex)
        }
        
        // Haptic feedback
        let isHapticEnabled = UserDefaults.standard.bool(forKey: "isHapticEnabled", defaultValue: true)
        
        if isCorrect {
            // Correct answer - move to next question
            if isHapticEnabled {
                HapticService.shared.success()
            }
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
            }
        } else {
            // Wrong answer - show score page (don't restart immediately)
            if isHapticEnabled {
                HapticService.shared.error()
            }
            lastScore = quizScore
            
            // Show results page with options to continue or restart
            showQuizResults = true
        }
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        quizAnswers = []
        quizScore = 0
        showQuizResults = false
        lastScore = 0
    }
    
    /// Continue to next question after wrong answer (ignore the wrong answer)
    func continueToNextQuestion() {
        // Hide results
        showQuizResults = false
        
        // Move to next question (don't increment score, just continue)
        if currentQuestionIndex < quizQuestions.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentQuestionIndex += 1
            }
        } else {
            // Reached the end - show final results
            withAnimation {
                showQuizResults = true
            }
        }
    }
}


