import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    var scene: SCNScene?

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true // ✅ Enable camera movement
        sceneView.backgroundColor = .black  // ✅ White background
        sceneView.scene = scene
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = scene
    }
}
