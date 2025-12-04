import SwiftUI
import Foundation

/// Quiz ViewModel for Safety Tips page - combines all step questions
class SafetyTipsQuizViewModel: GenericQuizViewModel {
    init(safetyViewModel: SafetyTipsViewModel) {
        // Collect all questions from all steps
        let allQuestions = (0..<safetyViewModel.safetyTips.count).map { step in
            let quizQ = safetyViewModel.getQuizQuestion(for: step)
            return QuizQuestion(
                question: quizQ.question,
                options: quizQ.options,
                correctAnswer: quizQ.correctAnswer
            )
        }
        super.init(questions: allQuestions)
    }
}

