import SwiftUI
import Foundation

/// Quiz ViewModel for History of Earth page - combines all step questions
class EarthHistoryQuizViewModel: GenericQuizViewModel {
    init(historyViewModel: EarthHistoryViewModel) {
        // Collect all questions from all steps
        let allQuestions = (0..<historyViewModel.historyStages.count).map { step in
            let quizQ = historyViewModel.getQuizQuestion(for: step)
            return QuizQuestion(
                question: quizQ.question,
                options: quizQ.options,
                correctAnswer: quizQ.correctAnswer
            )
        }
        super.init(questions: allQuestions)
    }
}

