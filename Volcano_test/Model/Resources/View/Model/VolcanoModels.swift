import SwiftUI
import Foundation

// MARK: - Volcano Part Model
struct VolcanoPartInfo: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let shortDescription: String
    let fullDescription: String
    let microStory: String
    let funFact: String
    let color: Color
    let iconName: String
    
    init(
        name: String,
        emoji: String,
        shortDescription: String,
        fullDescription: String,
        microStory: String,
        funFact: String,
        color: Color,
        iconName: String
    ) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.microStory = microStory
        self.funFact = funFact
        self.color = color
        self.iconName = iconName
    }
}

// MARK: - Quiz Question Model
struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

