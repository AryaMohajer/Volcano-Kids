import SwiftUI

class VolcanoViewModel: ObservableObject {
    @Published var selectedVolcano: Volcano?
    
    let volcanoes = [
        Volcano(name: "Ojos del Salado", imageName: "Ojos del Salado"),
        Volcano(name: "Mount Erebus", imageName: "Mount Erebus"),
        Volcano(name: "Mauna Loa", imageName: "Mauna Loa"),
        Volcano(name: "Mount Tambora", imageName: "Mount Tambora")
    ]
}
