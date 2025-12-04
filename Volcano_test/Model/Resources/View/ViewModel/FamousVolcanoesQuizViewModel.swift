import SwiftUI
import Foundation

/// Quiz ViewModel for Famous Volcanoes page - combines all volcano questions
class FamousVolcanoesQuizViewModel: GenericQuizViewModel {
    init(famousViewModel: FamousVolcanoesViewModel) {
        // Collect all questions from all volcanoes
        let allQuestions = (0..<famousViewModel.famousVolcanoes.count).map { step in
            let quizQ = famousViewModel.getQuizQuestion(for: step)
            return QuizQuestion(
                question: quizQ.question,
                options: quizQ.options,
                correctAnswer: quizQ.correctAnswer
            )
        }
        super.init(questions: allQuestions)
    }
}

