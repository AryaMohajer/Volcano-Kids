import SwiftUI
import Foundation

// MARK: - Earth History Models
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

// MARK: - Volcano Intro Models
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

// MARK: - Famous Volcanoes Models
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

// MARK: - Volcano Types Models
struct VolcanoTypeInfo: Identifiable {
    let id: UUID
    let name: String
    let emoji: String
    let shortDescription: String
    let fullDescription: String
    let microStory: String
    let funFact: String
    let characteristics: [String]
    let example: String
    let color: Color
    let iconName: String
    
    init(
        name: String,
        emoji: String,
        shortDescription: String,
        fullDescription: String,
        microStory: String,
        funFact: String,
        characteristics: [String],
        example: String,
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
        self.characteristics = characteristics
        self.example = example
        self.color = color
        self.iconName = iconName
    }
}

// MARK: - Safety Tips Models
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

// MARK: - Rocks Models
struct VolcanoRock: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let description: String
    let microStory: String
    let funFact: String
    let color: Color
    let icon: String
}

struct VolcanoMineral: Identifiable {
    let id: Int
    let name: String
    let emoji: String
    let description: String
    let funFact: String
    let color: Color
}

struct RocksQuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
}

