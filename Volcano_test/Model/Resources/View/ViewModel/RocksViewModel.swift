import SwiftUI
import Foundation

/// ViewModel for Volcano Rocks & Minerals page
class RocksViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var revealedFacts: Set<Int> = []
    @Published var matchedPairs: Set<Int> = []
    @Published var selectedRock: Int? = nil
    @Published var currentQuizAnswer: Int? = nil
    @Published var showQuizResult = false
    @Published var isQuizCorrect = false
    
    var totalSteps: Int {
        rocks.count
    }
    
    var isLastStep: Bool {
        currentStep == rocks.count - 1
    }
    
    func nextStep() {
        if currentStep < rocks.count - 1 {
            // Reset quiz state for the new step
            resetQuizState()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentStep += 1
            }
        }
    }
    
    func resetQuizState() {
        currentQuizAnswer = nil
        showQuizResult = false
        isQuizCorrect = false
    }
    
    let rocks: [VolcanoRock] = [
        VolcanoRock(
            id: 0,
            name: "Lava Rock",
            emoji: "🪨",
            description: "Lava rock is formed when hot lava cools down and turns into solid rock!",
            microStory: "Imagine hot, glowing lava flowing down a mountain. As it cools, it hardens and turns into dark, bumpy rocks. These rocks are called lava rocks!",
            funFact: "Lava rock is very light and full of tiny holes, like a sponge!",
            color: .red,
            icon: "flame.fill"
        ),
        VolcanoRock(
            id: 1,
            name: "Pumice",
            emoji: "🧽",
            description: "Pumice is a special rock that floats on water! It's full of tiny bubbles.",
            microStory: "When a volcano erupts, sometimes the lava has lots of bubbles in it, like soda! When it cools, it becomes pumice - a rock so light it can float!",
            funFact: "People use pumice to scrub their feet because it's so rough!",
            color: .gray,
            icon: "bubble.left.and.bubble.right.fill"
        ),
        VolcanoRock(
            id: 2,
            name: "Obsidian",
            emoji: "⚫",
            description: "Obsidian is a shiny, black rock that looks like glass! It's very sharp.",
            microStory: "Long ago, people used obsidian to make tools and weapons because it's so sharp! It forms when lava cools very, very quickly.",
            funFact: "Obsidian is sharper than a surgeon's scalpel!",
            color: .black,
            icon: "sparkles"
        ),
        VolcanoRock(
            id: 3,
            name: "Basalt",
            emoji: "🌑",
            description: "Basalt is a dark, heavy rock that forms most of the ocean floor!",
            microStory: "When lava flows into the ocean, it cools quickly and becomes basalt. Most of the ground under the ocean is made of basalt!",
            funFact: "Basalt is the most common rock on Earth!",
            color: .blue,
            icon: "water.waves"
        )
    ]
    
    let minerals: [VolcanoMineral] = [
        VolcanoMineral(
            id: 0,
            name: "Sulfur",
            emoji: "💛",
            description: "Sulfur is a yellow mineral that smells like rotten eggs!",
            funFact: "Sulfur is used to make matches and fireworks!",
            color: .yellow
        ),
        VolcanoMineral(
            id: 1,
            name: "Quartz",
            emoji: "💎",
            description: "Quartz is a beautiful crystal that forms in volcanoes!",
            funFact: "Quartz is used in watches because it keeps perfect time!",
            color: .cyan
        )
    ]
    
    // Different quiz question for each rock
    func getQuizQuestion(for step: Int) -> RocksQuizQuestion {
        switch step {
        case 0: // Lava Rock
            return RocksQuizQuestion(
                question: "What is lava rock formed from?",
                options: ["Water", "Hot lava that cools down", "Ice", "Sand"],
                correctAnswer: 1
            )
        case 1: // Pumice
            return RocksQuizQuestion(
                question: "Which rock can float on water?",
                options: ["Lava rock", "Pumice", "Obsidian", "Basalt"],
                correctAnswer: 1
            )
        case 2: // Obsidian
            return RocksQuizQuestion(
                question: "What color is obsidian?",
                options: ["Red", "Yellow", "Black", "Blue"],
                correctAnswer: 2
            )
        case 3: // Basalt
            return RocksQuizQuestion(
                question: "What is the most common rock on Earth?",
                options: ["Pumice", "Obsidian", "Basalt", "Diamond"],
                correctAnswer: 2
            )
        default:
            return RocksQuizQuestion(
                question: "What is lava rock formed from?",
                options: ["Water", "Hot lava that cools down", "Ice", "Sand"],
                correctAnswer: 1
            )
        }
    }
    
    func toggleFactReveal(_ id: Int) {
        if revealedFacts.contains(id) {
            revealedFacts.remove(id)
        } else {
            revealedFacts.insert(id)
        }
    }
    
    func selectRock(_ id: Int) {
        if selectedRock == id {
            selectedRock = nil
        } else {
            selectedRock = id
        }
    }
    
    func checkQuizAnswer(_ answerIndex: Int, for question: RocksQuizQuestion) {
        currentQuizAnswer = answerIndex
        isQuizCorrect = answerIndex == question.correctAnswer
        showQuizResult = true
        
        // Only hide feedback for wrong answers after a delay
        // Keep correct answers visible
        if !isQuizCorrect {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showQuizResult = false
                self.currentQuizAnswer = nil
            }
        }
    }
}


