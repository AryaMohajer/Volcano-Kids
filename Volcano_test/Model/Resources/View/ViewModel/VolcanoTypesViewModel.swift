import SwiftUI
import Foundation

/// ViewModel for managing the Types of Volcanoes educational content
class VolcanoTypesViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var revealedFacts: Set<Int> = []
    
    let volcanoTypes: [VolcanoTypeInfo] = [
        VolcanoTypeInfo(
            name: "Shield Volcano",
            emoji: "🛡️",
            shortDescription: "Wide and flat like a pancake!",
            fullDescription: "Shield volcanoes are wide and flat, like a pancake! They are made from many layers of thin, runny lava that flows slowly and spreads far. Think of them as the gentle giants of volcanoes.",
            microStory: "Imagine a volcano that's so wide and flat, it looks like a giant shield lying on the ground! The lava flows slowly and gently, spreading out in all directions. Over thousands of years, these gentle flows build up to create a huge, flat mountain that's perfect for hiking!",
            funFact: "Mauna Loa in Hawaii is a shield volcano and is the largest volcano on Earth!",
            characteristics: ["Very wide and flat", "Made from runny lava", "Gentle slopes", "Can be huge!"],
            example: "Mauna Loa in Hawaii",
            color: .brown,
            iconName: "shield.fill"
        ),
        VolcanoTypeInfo(
            name: "Composite Volcano",
            emoji: "🗻",
            shortDescription: "Tall and pointy like an ice cream cone!",
            fullDescription: "Composite volcanoes are tall and pointy, like an ice cream cone! They are made from layers of lava and ash that build up over time. They can be very dangerous when they erupt!",
            microStory: "Picture a perfect ice cream cone, but made of rock! These volcanoes grow tall and pointy because they erupt with both lava and ash. Each eruption adds a new layer, making the volcano taller and taller. They're like nature's own skyscrapers!",
            funFact: "Mount Fuji in Japan is a composite volcano and is considered one of the most beautiful mountains in the world!",
            characteristics: ["Tall and pointy", "Made from lava and ash", "Steep sides", "Can erupt explosively!"],
            example: "Mount Fuji in Japan",
            color: .gray,
            iconName: "mountain.2.fill"
        ),
        VolcanoTypeInfo(
            name: "Cinder Cone",
            emoji: "🏔️",
            shortDescription: "Small and steep like a perfect cone!",
            fullDescription: "Cinder cone volcanoes are small and steep! They look like a perfect cone made from cinders and ash. They are the smallest type of volcano, but still very powerful!",
            microStory: "Think of a small, perfect cone made from dark cinders and ash. These volcanoes form quickly when hot lava shoots into the air and falls back down as cinders. They're like nature's own sandcastles, but made of fire and rock!",
            funFact: "Parícutin in Mexico appeared suddenly in a farmer's field in 1943 and grew to 336 meters tall in just one year!",
            characteristics: ["Small and steep", "Made from cinders", "Perfect cone shape", "Usually short-lived"],
            example: "Parícutin in Mexico",
            color: .orange,
            iconName: "triangle.fill"
        )
    ]
    
    var totalSteps: Int {
        volcanoTypes.count
    }
    
    var currentType: VolcanoTypeInfo {
        volcanoTypes[currentStep]
    }
    
    var isFirstStep: Bool {
        currentStep == 0
    }
    
    var isLastStep: Bool {
        currentStep == volcanoTypes.count - 1
    }
    
    func nextStep() {
        if currentStep < volcanoTypes.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentStep += 1
            }
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                currentStep -= 1
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
    
    func isFactRevealed(for index: Int) -> Bool {
        revealedFacts.contains(index)
    }
    
    // Quiz questions for each volcano type
    func getQuizQuestion(for step: Int) -> QuizQuestion {
        switch step {
        case 0: // Shield Volcano
            return QuizQuestion(
                question: "What shape are shield volcanoes?",
                options: ["Tall and pointy", "Wide and flat", "Small and steep", "Round"],
                correctAnswer: 1
            )
        case 1: // Composite Volcano
            return QuizQuestion(
                question: "What are composite volcanoes made of?",
                options: ["Only lava", "Layers of lava and ash", "Only ash", "Water"],
                correctAnswer: 1
            )
        case 2: // Cinder Cone
            return QuizQuestion(
                question: "What is the smallest type of volcano?",
                options: ["Shield volcano", "Composite volcano", "Cinder cone", "All are the same size"],
                correctAnswer: 2
            )
        default:
            return QuizQuestion(
                question: "What shape are shield volcanoes?",
                options: ["Tall and pointy", "Wide and flat", "Small and steep", "Round"],
                correctAnswer: 1
            )
        }
    }
}


