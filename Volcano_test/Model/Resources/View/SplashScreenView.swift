import SwiftUI

struct SplashScreenView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var iconScale: CGFloat = 0.85
    @State private var glowOpacity: Double = 0.4
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        let themeColors = themeManager.themeColors
        
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: themeColors.backgroundGradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 26) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 200, height: 200)
                        .blur(radius: 20)
                        .opacity(glowOpacity)
                    
                    Image("icon_splashscreen")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .scaleEffect(iconScale)
                        .shadow(color: themeColors.accent.opacity(0.6), radius: 10, x: 0, y: 5)
                }
                
                VStack(spacing: 12) {
                    Text("Volcano Explorer")
                        .font(.custom("Noteworthy-Bold", size: 42))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                        .opacity(textOpacity)
                    
                    Text("let's spark a lava adventure!")
                        .font(.custom("Noteworthy-Bold", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.white.opacity(0.9))
                        .padding(.horizontal, 40)
                        .opacity(textOpacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                glowOpacity = 0.9
            }
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6, blendDuration: 0.5)) {
                iconScale = 1.0
            }
            withAnimation(.easeIn(duration: 1.0).delay(0.4)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
