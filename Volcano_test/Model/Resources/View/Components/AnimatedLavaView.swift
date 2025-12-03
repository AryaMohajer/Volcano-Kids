import SwiftUI

/// Simple animated lava flow effect
struct AnimatedLavaView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Lava flow path
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    path.move(to: CGPoint(x: width * 0.3, y: 0))
                    path.addCurve(
                        to: CGPoint(x: width * 0.7, y: height),
                        control1: CGPoint(x: width * 0.4, y: height * 0.3),
                        control2: CGPoint(x: width * 0.6, y: height * 0.7)
                    )
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.8),
                            Color.orange.opacity(0.8),
                            Color.yellow.opacity(0.6)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .offset(y: animate ? 20 : -20)
                .opacity(animate ? 0.6 : 0.9)
                .animation(
                    Animation.linear(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: animate
                )
            }
        }
        .frame(height: 100)
        .onAppear {
            animate = true
        }
    }
}

