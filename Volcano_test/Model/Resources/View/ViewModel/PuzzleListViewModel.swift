import Foundation
import SwiftUI

struct PuzzleItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageName: String
    let puzzleIndex: Int  // Added to map to PuzzleView
    let text: String  // Added extra text info
    
    init(title: String, subtitle: String, imageName: String, puzzleIndex: Int, text: String) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.puzzleIndex = puzzleIndex
        self.text = text
    }
}

// MARK: - ViewModel
class PuzzleListViewModel: ObservableObject {
    @Published var puzzleItems: [PuzzleItem] = [
        PuzzleItem(title: "Mauna Loa", subtitle: "The biggest volcano in the world!", imageName: "Mauna Loa", puzzleIndex: 0, text: "A long time ago, the volcano Mauna Loa was home to Pele, the fire goddess. She loved to dance and play, sending bright red lava down the mountain to create new land. But her sister, Namaka, the ocean goddess, didn't like this and tried to stop her with big waves. The lava sizzled and turned into black rocks, but Pele kept going, making the island bigger and stronger. Even today, people say Pele's spirit lives in Mauna Loa, and when the lava flows, it's her way of painting the land with fire! "),
        
        PuzzleItem(title: "Mount Tambora", subtitle: "A long time ago, it made the biggest erupt ever!", imageName: "Mount Tambora", puzzleIndex: 1, text: "A long time ago, Mount Tambora was home to a mighty spirit who slept deep inside the mountain. But one day, the spirit became angry and roared so loudly that the whole sky turned dark! Ash and fire burst from the mountain, and the ground shook. The people in the villages below were scared, but they learned to listen to the mountain and respect its power. Over time, plants and animals returned, and the land became green again. Today, the people say that Tambora sleeps once more, but they always watch and listen, just in case the great spirit wakes up again! "),
        
        PuzzleItem(title: "Mount Erebus", subtitle: "A volcano that lives in the land of ice!", imageName: "Mount Erebus", puzzleIndex: 2, text: "A long time ago, people believed that Mount Erebus, the great volcano in Antarctica, was home to a fiery spirit that kept a blue flame burning inside its crater. Even in the coldest place on Earth, the volcano never stopped glowing! Explorers who traveled to the icy land saw smoke and bubbling lava inside the mountain and thought it was a magical fire that could never go out. Even today, Mount Erebus still sends up puffs of smoke, as if the spirit inside is breathing, keeping its secret flame alive in the land of ice and snow! "),
        
        PuzzleItem(title: "Ojos del Salado", subtitle: "So high, it touches the sky!", imageName: "Ojos del Salado", puzzleIndex: 3, text: "Long ago, people believed that Ojos del Salado, the tallest volcano in the world, was home to a giant spirit who loved the sky. High in the Andes Mountains, where the air is thin and cold, the spirit watched over the land, guarding a hidden lake near the top. Travelers who climbed the volcano would feel the wind whispering stories of the ancient guardian. Some say that on clear nights, the spirit still watches from the snowy peak, making sure the mountain stays strong and peaceful.")
    ]
}
