import SwiftUI
import Foundation

/// ViewModel for History of Earth page
class EarthHistoryViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var revealedFacts: Set<Int> = []
    @Published var currentQuizAnswer: Int? = nil
    @Published var showQuizResult = false
    @Published var isQuizCorrect = false
    
    let historyStages: [EarthHistoryStage] = [
        EarthHistoryStage(
            id: 0,
            title: "The Hot Beginning",
            emoji: "🔥",
            description: "A long time ago, Earth was very different. It was super hot! Giant volcanoes exploded with fire and smoke, and the sky was dark with big black clouds.",
            microStory: "Imagine Earth as a giant ball of fire! Volcanoes were everywhere, shooting hot lava and smoke into the sky. The whole planet was glowing red and orange, like a giant campfire in space!",
            funFact: "Earth was so hot that rocks were melted into liquid!",
            color: .red
        ),
        EarthHistoryStage(
            id: 1,
            title: "No Life Yet",
            emoji: "🌋",
            description: "There were no trees, no rivers, and no animals - just fire, and red-hot rocks everywhere.",
            microStory: "Picture a world with no green grass, no blue oceans, and no animals playing. Everything was just hot, glowing rocks and fire. It was like a giant oven that never turned off!",
            funFact: "The first life on Earth appeared billions of years after it formed!",
            color: .orange
        ),
        EarthHistoryStage(
            id: 2,
            title: "Everything Was Hot",
            emoji: "🌡️",
            description: "Everything was super hot, with no cool place to rest. The ground was burning, and the whole Earth was bright red!",
            microStory: "There was no place to hide from the heat! The ground was so hot you couldn't walk on it, and the air was filled with smoke and fire. It was like being inside a volcano all the time!",
            funFact: "Early Earth's temperature was over 1,000°C - hotter than a pizza oven!",
            color: .yellow
        )
    ]
    
    // Different quiz question for each step
    func getQuizQuestion(for step: Int) -> HistoryQuizQuestion {
        switch step {
        case 0:
            return HistoryQuizQuestion(
                question: "What was Earth like a long time ago?",
                options: ["Cold and icy", "Hot and full of fire", "Green with trees", "Blue with oceans"],
                correctAnswer: 1
            )
        case 1:
            return HistoryQuizQuestion(
                question: "What was everywhere on early Earth?",
                options: ["Trees", "Animals", "Volcanoes", "Cities"],
                correctAnswer: 2
            )
        case 2:
            return HistoryQuizQuestion(
                question: "What color was early Earth?",
                options: ["Blue", "Green", "Red and orange", "White"],
                correctAnswer: 2
            )
        default:
            return HistoryQuizQuestion(
                question: "What was Earth like a long time ago?",
                options: ["Cold and icy", "Hot and full of fire", "Green with trees", "Blue with oceans"],
                correctAnswer: 1
            )
        }
    }
    
    var totalSteps: Int {
        historyStages.count
    }
    
    var isLastStep: Bool {
        currentStep == historyStages.count - 1
    }
    
    func nextStep() {
        if currentStep < historyStages.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentStep += 1
            }
        }
    }
    
    func toggleFactReveal(for index: Int) {
        if revealedFacts.contains(index) {
            revealedFacts.remove(index)
        } else {
            revealedFacts.insert(index)
        }
    }
    
    func checkQuizAnswer(_ answerIndex: Int, for question: HistoryQuizQuestion) {
        currentQuizAnswer = answerIndex
        isQuizCorrect = answerIndex == question.correctAnswer
        showQuizResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showQuizResult = false
            self.currentQuizAnswer = nil
        }
    }
}

struct EarthHistoryStage: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let description: String
    let microStory: String
    let funFact: String
    let color: Color
}

struct HistoryQuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

