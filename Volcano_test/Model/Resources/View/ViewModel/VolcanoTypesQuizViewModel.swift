import SwiftUI
import Foundation

/// Quiz ViewModel for Types of Volcanoes page - combines all type questions
class VolcanoTypesQuizViewModel: GenericQuizViewModel {
    init(typesViewModel: VolcanoTypesViewModel) {
        // Collect all questions from all types
        let allQuestions = (0..<typesViewModel.volcanoTypes.count).map { step in
            typesViewModel.getQuizQuestion(for: step)
        }
        super.init(questions: allQuestions)
    }
}

