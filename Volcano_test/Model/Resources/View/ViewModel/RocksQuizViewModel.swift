import SwiftUI
import Foundation

/// Quiz ViewModel for Volcano Rocks page - combines all rock questions
class RocksQuizViewModel: GenericQuizViewModel {
    init(rocksViewModel: RocksViewModel) {
        // Collect all questions from all rocks
        let allQuestions = (0..<rocksViewModel.rocks.count).map { step in
            let quizQ = rocksViewModel.getQuizQuestion(for: step)
            return QuizQuestion(
                question: quizQ.question,
                options: quizQ.options,
                correctAnswer: quizQ.correctAnswer
            )
        }
        super.init(questions: allQuestions)
    }
}

