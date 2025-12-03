import SwiftUI
import Foundation

/// ViewModel for managing the Parts of a Volcano educational content
class VolcanoPartsViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var revealedFacts: Set<Int> = []
    
    let volcanoParts: [VolcanoPartInfo] = [
        VolcanoPartInfo(
            name: "Crater",
            emoji: "🌋",
            shortDescription: "The big opening at the top!",
            fullDescription: "The crater is the big opening at the very top of the volcano! It's like a giant bowl where hot lava comes out when the volcano erupts. Think of it as the volcano's mouth!",
            microStory: "Imagine you're looking down into a giant bowl at the top of a mountain. That's the crater! When the volcano wakes up, hot lava bubbles up and flows out of this opening, like a pot boiling over!",
            funFact: "Some craters are so big, you could fit a whole city inside them!",
            color: .red,
            iconName: "mountain.2.fill"
        ),
        VolcanoPartInfo(
            name: "Vent",
            emoji: "🕳️",
            shortDescription: "The secret tunnel inside!",
            fullDescription: "The vent is like a tunnel inside the volcano! It's the pathway that helps hot magma travel from deep underground all the way up to the crater. It's the volcano's secret passage!",
            microStory: "Deep inside the volcano, there's a special tunnel called the vent. It's like a secret passageway! Hot magma travels through this tunnel, moving from the bottom all the way to the top, just like water flowing through a pipe!",
            funFact: "The vent can be very narrow or super wide, depending on the volcano!",
            color: .orange,
            iconName: "arrow.up.circle.fill"
        ),
        VolcanoPartInfo(
            name: "Magma Chamber",
            emoji: "🔥",
            shortDescription: "The hidden treasure room!",
            fullDescription: "Deep, deep underground, there's a special room called the magma chamber. This is where super hot, melted rock called magma waits and gets ready to erupt! It's like the volcano's hidden treasure room!",
            microStory: "Way down below the ground, there's a huge room filled with super hot, melted rock called magma. It's like a giant underground swimming pool, but instead of water, it's filled with glowing, orange-hot rock that's waiting to burst out!",
            funFact: "The magma chamber can be as big as a whole mountain!",
            color: .yellow,
            iconName: "flame.fill"
        ),
        VolcanoPartInfo(
            name: "Lava Flow",
            emoji: "🌊",
            shortDescription: "The hot river of fire!",
            fullDescription: "When magma comes out of the crater, it becomes lava! Lava flows down the sides of the volcano like a hot, glowing river. It's bright red and orange, and it's super, super hot!",
            microStory: "When the volcano erupts, the hot magma becomes lava and flows down the mountain like a river of fire! It glows bright red and orange, moving slowly but steadily, creating new land as it cools down and turns into rock!",
            funFact: "Lava can flow as fast as a car on a highway!",
            color: .red,
            iconName: "waveform.path"
        ),
        VolcanoPartInfo(
            name: "Ash Cloud",
            emoji: "☁️",
            shortDescription: "The dark cloud in the sky!",
            fullDescription: "When a volcano erupts, it shoots tiny pieces of rock and dust high into the sky! This creates a big, dark cloud called an ash cloud. It's like nature's own fireworks show!",
            microStory: "When a volcano erupts, it shoots millions of tiny pieces of rock and dust high up into the sky! These tiny pieces form a huge, dark cloud that can travel for miles and miles, carried by the wind like a giant gray blanket covering the sky!",
            funFact: "Ash clouds can travel all around the world in the wind!",
            color: .gray,
            iconName: "cloud.fill"
        ),
        VolcanoPartInfo(
            name: "Volcano Cone",
            emoji: "⛰️",
            shortDescription: "The mountain shape!",
            fullDescription: "The cone is the mountain shape of the volcano! It's built up over thousands of years from layers of lava, ash, and rocks that pile up after each eruption. It's like nature's own pyramid!",
            microStory: "Every time a volcano erupts, it leaves behind layers of lava and ash. Over thousands of years, these layers pile up and up, creating the tall, cone-shaped mountain we see today. It's like building a tower, one layer at a time!",
            funFact: "Some volcano cones are so tall, they reach above the clouds!",
            color: .brown,
            iconName: "triangle.fill"
        )
    ]
    
    var totalSteps: Int {
        volcanoParts.count
    }
    
    var currentPart: VolcanoPartInfo {
        volcanoParts[currentStep]
    }
    
    var isFirstStep: Bool {
        currentStep == 0
    }
    
    var isLastStep: Bool {
        currentStep == volcanoParts.count - 1
    }
    
    func nextStep() {
        if currentStep < volcanoParts.count - 1 {
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
}

/// Enhanced volcano part information model
struct VolcanoPartInfo: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let shortDescription: String
    let fullDescription: String
    let microStory: String
    let funFact: String
    let color: Color
    let iconName: String
}

