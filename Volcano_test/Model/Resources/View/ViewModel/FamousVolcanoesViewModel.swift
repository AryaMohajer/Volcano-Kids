import SwiftUI
import Foundation

/// ViewModel for Famous Volcanoes page
class FamousVolcanoesViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var revealedFacts: Set<Int> = []
    @Published var currentQuizAnswer: Int? = nil
    @Published var showQuizResult = false
    @Published var isQuizCorrect = false
    
    let famousVolcanoes: [FamousVolcano] = [
        FamousVolcano(
            id: 0,
            flag: "🇯🇵",
            title: "Mount Fuji",
            location: "Japan",
            description: "Mount Fuji is Japan's tallest and most famous volcano! It's a perfect cone shape and is considered sacred. It last erupted in 1707, but it's still an active volcano!",
            microStory: "Mount Fuji is like a giant, perfect ice cream cone made of rock! People in Japan love it so much that they climb it every year. It's so beautiful that artists have painted it for hundreds of years!",
            funFact: "Mount Fuji is a UNESCO World Heritage Site and is featured in many Japanese artworks!",
            height: "3,776 meters",
            color: .blue
        ),
        FamousVolcano(
            id: 1,
            flag: "🇮🇹",
            title: "Mount Vesuvius",
            location: "Italy",
            description: "Mount Vesuvius is famous for destroying the ancient city of Pompeii in 79 AD! It's one of the most dangerous volcanoes in the world because millions of people live nearby.",
            microStory: "Long ago, Mount Vesuvius erupted and covered the city of Pompeii with ash, preserving it like a time capsule! Today, we can visit and see how people lived 2,000 years ago. It's like stepping back in time!",
            funFact: "Mount Vesuvius is the only active volcano on mainland Europe!",
            height: "1,281 meters",
            color: .green
        ),
        FamousVolcano(
            id: 2,
            flag: "🇺🇸",
            title: "Kīlauea",
            location: "Hawaii, USA",
            description: "Kīlauea is one of the most active volcanoes in the world! It's a shield volcano that creates beautiful, slow-moving lava flows. People can safely watch the lava flow!",
            microStory: "Kīlauea is like a gentle giant! It erupts almost all the time, but the lava flows slowly, so people can watch it safely. The glowing red lava creates new land as it flows into the ocean, making Hawaii bigger and bigger!",
            funFact: "Kīlauea has been erupting almost continuously since 1983!",
            height: "1,247 meters",
            color: .orange
        ),
        FamousVolcano(
            id: 3,
            flag: "🇮🇩",
            title: "Krakatoa",
            location: "Indonesia",
            description: "Krakatoa is famous for one of the biggest eruptions in history! When it erupted in 1883, the sound was so loud it could be heard 3,000 miles away!",
            microStory: "When Krakatoa erupted, it was so powerful that the sound traveled around the world four times! The explosion was like 13,000 atomic bombs going off at once. It created huge waves and changed the weather all over the world!",
            funFact: "The Krakatoa eruption was so loud, it's considered the loudest sound in recorded history!",
            height: "813 meters",
            color: .red
        ),
        FamousVolcano(
            id: 4,
            flag: "🇺🇸",
            title: "Mount St. Helens",
            location: "Washington, USA",
            description: "Mount St. Helens erupted in 1980 in one of the most famous eruptions in modern times! It lost its top and created a huge crater.",
            microStory: "Mount St. Helens was a beautiful, perfect mountain until 1980, when it erupted and blew off its top! The eruption was so powerful that it flattened forests for miles around. But nature is amazing - new life is growing back!",
            funFact: "Mount St. Helens lost 1,300 feet of its height in the 1980 eruption!",
            height: "2,549 meters",
            color: .purple
        )
    ]
    
    // Different quiz question for each volcano
    func getQuizQuestion(for step: Int) -> FamousVolcanoQuizQuestion {
        switch step {
        case 0: // Mount Fuji
            return FamousVolcanoQuizQuestion(
                question: "Which volcano is in Japan?",
                options: ["Mount Vesuvius", "Mount Fuji", "Kīlauea", "Krakatoa"],
                correctAnswer: 1
            )
        case 1: // Mount Vesuvius
            return FamousVolcanoQuizQuestion(
                question: "Which volcano destroyed Pompeii?",
                options: ["Mount Fuji", "Mount Vesuvius", "Krakatoa", "Mount St. Helens"],
                correctAnswer: 1
            )
        case 2: // Kīlauea
            return FamousVolcanoQuizQuestion(
                question: "Which volcano has been erupting almost continuously since 1983?",
                options: ["Mount Fuji", "Mount Vesuvius", "Kīlauea", "Krakatoa"],
                correctAnswer: 2
            )
        case 3: // Krakatoa
            return FamousVolcanoQuizQuestion(
                question: "Which volcano made the loudest sound in recorded history?",
                options: ["Mount Fuji", "Mount Vesuvius", "Krakatoa", "Mount St. Helens"],
                correctAnswer: 2
            )
        case 4: // Mount St. Helens
            return FamousVolcanoQuizQuestion(
                question: "Which volcano lost 1,300 feet of height in 1980?",
                options: ["Mount Fuji", "Mount Vesuvius", "Krakatoa", "Mount St. Helens"],
                correctAnswer: 3
            )
        default:
            return FamousVolcanoQuizQuestion(
                question: "Which volcano is in Japan?",
                options: ["Mount Vesuvius", "Mount Fuji", "Kīlauea", "Krakatoa"],
                correctAnswer: 1
            )
        }
    }
    
    var totalSteps: Int {
        famousVolcanoes.count
    }
    
    var isLastStep: Bool {
        currentStep == famousVolcanoes.count - 1
    }
    
    func nextStep() {
        if currentStep < famousVolcanoes.count - 1 {
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
    
    func checkQuizAnswer(_ answerIndex: Int, for question: FamousVolcanoQuizQuestion) {
        currentQuizAnswer = answerIndex
        isQuizCorrect = answerIndex == question.correctAnswer
        showQuizResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showQuizResult = false
            self.currentQuizAnswer = nil
        }
    }
}

struct FamousVolcano: Identifiable {
    let id: Int
    let flag: String
    let title: String
    let location: String
    let description: String
    let microStory: String
    let funFact: String
    let height: String
    let color: Color
}

struct FamousVolcanoQuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

