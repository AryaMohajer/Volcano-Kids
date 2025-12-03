import SwiftUI
import Foundation

/// ViewModel for Volcano Safety Tips page
class SafetyTipsViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var selectedSafetyItems: Set<Int> = []
    @Published var revealedFacts: Set<Int> = []
    @Published var currentQuizAnswer: Int? = nil
    @Published var showQuizResult = false
    @Published var isQuizCorrect = false
    
    let safetyTips: [SafetyTip] = [
        SafetyTip(
            id: 0,
            title: "Stay Far Away!",
            emoji: "🏃",
            shortDescription: "Keep a safe distance!",
            description: "If you see a volcano erupting, stay far away! Volcanoes can be dangerous, so always keep a safe distance.",
            microStory: "Imagine you're watching a volcano from a safe hill far away. You can see the amazing lava and smoke, but you're safe because you're far enough!",
            funFact: "Volcanoes can shoot rocks and ash up to 30 kilometers away!",
            icon: "figure.walk",
            color: .red
        ),
        SafetyTip(
            id: 1,
            title: "Listen to Grown-ups",
            emoji: "👂",
            shortDescription: "Follow safety instructions!",
            description: "Always listen to adults and scientists when they say to leave an area. They know how to keep you safe!",
            microStory: "Scientists watch volcanoes all the time! They have special tools that tell them when a volcano might erupt, so they can warn everyone to stay safe.",
            funFact: "Scientists can predict some eruptions days or even weeks before they happen!",
            icon: "ear",
            color: .blue
        ),
        SafetyTip(
            id: 2,
            title: "Wear Protection",
            emoji: "🛡️",
            shortDescription: "Protect yourself!",
            description: "If you're near a volcano, wear a helmet and a mask. Ash and rocks can fall from the sky!",
            microStory: "Think of it like wearing a bike helmet, but for volcanoes! The helmet protects your head, and the mask helps you breathe clean air.",
            funFact: "Volcanic ash can travel thousands of kilometers in the wind!",
            icon: "shield.fill",
            color: .orange
        ),
        SafetyTip(
            id: 3,
            title: "Cover Your Nose & Mouth",
            emoji: "😷",
            shortDescription: "Breathe safely!",
            description: "Volcanic ash can make it hard to breathe. Always cover your nose and mouth with a mask or cloth!",
            microStory: "Volcanic ash is like tiny pieces of rock dust. It can float in the air and get into your lungs, so covering your face helps keep you healthy!",
            funFact: "Volcanic ash is so fine, it can travel around the entire world!",
            icon: "facemask.fill",
            color: .yellow
        ),
        SafetyTip(
            id: 4,
            title: "Stay Indoors",
            emoji: "🏠",
            shortDescription: "Go inside when ash falls!",
            description: "If ash is falling from the sky, go inside and close all windows and doors. Stay safe indoors!",
            microStory: "When ash falls, it's like a gray snowstorm! Just like you stay inside during a snowstorm, you should stay inside during an ash fall.",
            funFact: "Ash can pile up like snow and make roads slippery!",
            icon: "house.fill",
            color: .purple
        )
    ]
    
    let safetyGear: [SafetyGearItem] = [
        SafetyGearItem(id: 0, name: "Helmet", emoji: "⛑️", description: "Protects your head from falling rocks"),
        SafetyGearItem(id: 1, name: "Mask", emoji: "😷", description: "Helps you breathe clean air"),
        SafetyGearItem(id: 2, name: "Goggles", emoji: "🥽", description: "Protects your eyes from ash"),
        SafetyGearItem(id: 3, name: "Gloves", emoji: "🧤", description: "Keeps your hands safe from hot rocks"),
        SafetyGearItem(id: 4, name: "Boots", emoji: "🥾", description: "Protects your feet from hot ground")
    ]
    
    // Different quiz question for each step
    func getQuizQuestion(for step: Int) -> SafetyQuizQuestion {
        switch step {
        case 0: // Stay Far Away
            return SafetyQuizQuestion(
                question: "What should you do if you see a volcano erupting?",
                options: ["Run closer to see", "Stay far away", "Touch the lava", "Climb the volcano"],
                correctAnswer: 1
            )
        case 1: // Listen to Grown-ups
            return SafetyQuizQuestion(
                question: "Who should you listen to for volcano safety?",
                options: ["Friends", "Adults and scientists", "TV shows", "Nobody"],
                correctAnswer: 1
            )
        case 2: // Wear Protection
            return SafetyQuizQuestion(
                question: "What should you wear near a volcano?",
                options: ["Swimsuit", "Helmet and mask", "Nothing special", "Fancy clothes"],
                correctAnswer: 1
            )
        case 3: // Cover Nose & Mouth
            return SafetyQuizQuestion(
                question: "Why should you cover your nose and mouth near a volcano?",
                options: ["To look cool", "To keep ash out", "To stay warm", "To hide"],
                correctAnswer: 1
            )
        case 4: // Stay Indoors
            return SafetyQuizQuestion(
                question: "What should you do if ash is falling?",
                options: ["Play outside", "Stay indoors", "Eat the ash", "Make snow angels"],
                correctAnswer: 1
            )
        default:
            return SafetyQuizQuestion(
                question: "What should you do if you see a volcano erupting?",
                options: ["Run closer to see", "Stay far away", "Touch the lava", "Climb the volcano"],
                correctAnswer: 1
            )
        }
    }
    
    func toggleSafetyItem(_ id: Int) {
        if selectedSafetyItems.contains(id) {
            selectedSafetyItems.remove(id)
        } else {
            selectedSafetyItems.insert(id)
        }
    }
    
    func toggleFactReveal(_ id: Int) {
        if revealedFacts.contains(id) {
            revealedFacts.remove(id)
        } else {
            revealedFacts.insert(id)
        }
    }
    
    func checkQuizAnswer(_ answerIndex: Int, for question: SafetyQuizQuestion) {
        currentQuizAnswer = answerIndex
        isQuizCorrect = answerIndex == question.correctAnswer
        showQuizResult = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showQuizResult = false
            self.currentQuizAnswer = nil
        }
    }
    
    func nextStep() {
        if currentStep < safetyTips.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentStep += 1
            }
        }
    }
}

struct SafetyTip: Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let shortDescription: String
    let description: String
    let microStory: String
    let funFact: String
    let icon: String
    let color: Color
}

struct SafetyGearItem: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let description: String
}

struct SafetyQuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

