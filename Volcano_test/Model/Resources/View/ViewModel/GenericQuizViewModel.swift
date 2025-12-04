import SwiftUI
import Foundation

/// Generic Quiz ViewModel that can be used for any page
class GenericQuizViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var quizAnswers: [Int] = []
    @Published var showQuizResults: Bool = false
    @Published var quizScore: Int = 0
    @Published var lastScore: Int = 0
    
    let quizQuestions: [QuizQuestion]
    
    init(questions: [QuizQuestion]) {
        self.quizQuestions = questions
    }
    
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
            // Wrong answer - show score page
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

