import SwiftUI
import Foundation

/// Quiz ViewModel for What is Volcano page - combines all step questions
class VolcanoIntroQuizViewModel: GenericQuizViewModel {
    init(introViewModel: VolcanoIntroViewModel) {
        // Collect all questions from all steps
        let allQuestions = (0..<introViewModel.introStages.count).map { step in
            let quizQ = introViewModel.getQuizQuestion(for: step)
            return QuizQuestion(
                question: quizQ.question,
                options: quizQ.options,
                correctAnswer: quizQ.correctAnswer
            )
        }
        super.init(questions: allQuestions)
    }
}

