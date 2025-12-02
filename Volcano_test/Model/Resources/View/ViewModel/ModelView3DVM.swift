import Foundation
import SceneKit

@MainActor
class ModelView3D: ObservableObject {
    @Published var scene: SCNScene?

    func loadModel(named modelName: String) {
        Task {
            do {
                // ✅ Ensure the model file exists in the app bundle
                guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz") else {
                    print("❌ Model file not found: \(modelName).usdz")
                    return
                }

                // ✅ Load SceneKit scene
                let scene = try SCNScene(url: modelURL, options: nil)

                DispatchQueue.main.async {
                    self.scene = scene
                    print("✅ Successfully loaded SceneKit model: \(modelName).usdz")
                }
            } catch {
                print("❌ Failed to load model \(modelName): \(error.localizedDescription)")
            }
        }
    }
}
