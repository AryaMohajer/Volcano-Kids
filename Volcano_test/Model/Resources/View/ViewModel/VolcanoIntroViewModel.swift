import SwiftUI
import Foundation

/// ViewModel for What Is Volcano page
class VolcanoIntroViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var revealedFacts: Set<Int> = []
    @Published var currentQuizAnswer: Int? = nil
    @Published var showQuizResult = false
    @Published var isQuizCorrect = false
    
    let introStages: [VolcanoIntroStage] = [
        VolcanoIntroStage(
            id: 0,
            title: "What is a Volcano?",
            emoji: "🌋",
            description: "A volcano is an opening in the Earth's surface.",
            microStory: "Imagine the Earth has a special door that opens sometimes. When it opens, hot, melted rock called lava comes out! That door is called a volcano, and it's one of the most amazing things on our planet!",
            funFact: "There are about 1,500 active volcanoes in the world!",
            color: .red
        ),
        VolcanoIntroStage(
            id: 1,
            title: "Sleeping Volcanoes",
            emoji: "😴",
            description: "Some volcanoes sleep for a long, long time, while others wake up and erupt!",
            microStory: "Some volcanoes are like sleeping giants! They rest quietly for hundreds or thousands of years, but when they wake up, they can create amazing shows of fire and lava. It's like nature's own fireworks!",
            funFact: "Some volcanoes haven't erupted in over 10,000 years!",
            color: .blue
        ),
        VolcanoIntroStage(
            id: 2,
            title: "Volcano Eruptions",
            emoji: "💥",
            description: "When a volcano erupts, it looks like a fireworks show but with lava and ash instead of lights.",
            microStory: "When a volcano erupts, it's like the biggest, most amazing fireworks show you've ever seen! Bright red and orange lava shoots into the sky, and colorful ash clouds fill the air. It's nature's way of showing off its power!",
            funFact: "The biggest volcanic eruption in history happened 74,000 years ago!",
            color: .orange
        ),
        VolcanoIntroStage(
            id: 3,
            title: "Learning Together",
            emoji: "📚",
            description: "There are many volcanoes in the world, and we can learn about them together!",
            microStory: "Volcanoes are all around the world, and each one has its own special story! Some are tall and pointy, some are wide and flat, and some are even underwater! Let's explore them together and discover their amazing secrets!",
            funFact: "Volcanoes can be found on every continent, even Antarctica!",
            color: .purple
        )
    ]
    
    // Different quiz question for each step
    func getQuizQuestion(for step: Int) -> IntroQuizQuestion {
        switch step {
        case 0:
            return IntroQuizQuestion(
                question: "What is a volcano?",
                options: ["A mountain", "An opening in Earth's surface", "A lake", "A forest"],
                correctAnswer: 1
            )
        case 1:
            return IntroQuizQuestion(
                question: "How long can some volcanoes sleep?",
                options: ["A few days", "A few months", "Over 10,000 years", "Never"],
                correctAnswer: 2
            )
        case 2:
            return IntroQuizQuestion(
                question: "What comes out of a volcano when it erupts?",
                options: ["Water", "Lava and ash", "Snow", "Wind"],
                correctAnswer: 1
            )
        case 3:
            return IntroQuizQuestion(
                question: "Where can volcanoes be found?",
                options: ["Only on land", "Only underwater", "On every continent", "Only in hot places"],
                correctAnswer: 2
            )
        default:
            return IntroQuizQuestion(
                question: "What is a volcano?",
                options: ["A mountain", "An opening in Earth's surface", "A lake", "A forest"],
                correctAnswer: 1
            )
        }
    }
    
    var totalSteps: Int {
        introStages.count
    }
    
    var isLastStep: Bool {
        currentStep == introStages.count - 1
    }
    
    func nextStep() {
        if currentStep < introStages.count - 1 {
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
    
    func checkQuizAnswer(_ answerIndex: Int, for question: IntroQuizQuestion) {
        currentQuizAnswer = answerIndex
        isQuizCorrect = answerIndex == question.correctAnswer
        showQuizResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showQuizResult = false
            self.currentQuizAnswer = nil
        }
    }
}

struct VolcanoIntroStage: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let description: String
    let microStory: String
    let funFact: String
    let color: Color
}

struct IntroQuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

