import SwiftUI

struct DetailView3: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @State private var selectedPart: VolcanoPart? = nil
    @State private var showInteractiveVolcano = false
    @State private var pulseAnimation = false
    @State private var showPartsInfo = false
    @State private var showCelebration = false
    @State private var celebrationScale = 1.0
    @State private var showConfetti = false
    @Environment(\.presentationMode) var presentationMode
    
    // Volcano parts data
    let volcanoParts = [
        VolcanoPart(name: "Crater", description: "The opening at the top where lava comes out! It's like a big bowl where the magma bursts out and becomes lava!", position: CGPoint(x: 200, y: 80), emoji: "🌋"),
        VolcanoPart(name: "Vent", description: "The tunnel that helps magma escape! This vent is like a slide that magma travels up when it gets excited.", position: CGPoint(x: 200, y: 180), emoji: "🕳️"),
        VolcanoPart(name: "Magma Chamber", description: "Deep underground where hot, melted rock called magma waits like a sleepy dragon before it wakes up!", position: CGPoint(x: 200, y: 300), emoji: "🔥"),
        VolcanoPart(name: "Lava Flow", description: "When magma comes out of the crater, it becomes lava and flows down the mountain like a hot river!", position: CGPoint(x: 150, y: 120), emoji: "🌊"),
        VolcanoPart(name: "Ash Cloud", description: "Tiny pieces of rock and dust that shoot high into the sky during an eruption, like nature's fireworks!", position: CGPoint(x: 250, y: 40), emoji: "☁️")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Keep original background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        AppTheme.Colors.primaryBackground,
                        AppTheme.Colors.accent
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Title (removed duplicate back button)
                    Text("Parts of a Volcano")
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .shadow(radius: AppTheme.Shadows.medium)
                        .padding(.top, AppTheme.Spacing.medium)
                        .padding(.bottom, AppTheme.Spacing.medium)
                    
                    // Main content area
                    ScrollView {
                        VStack(spacing: 20) {
                            // Introduction text
                            Text("A volcano has different parts, just like a house has rooms. Tap on the glowing dots to explore each part!")
                                .multilineTextAlignment(.center)
                                .foregroundColor(AppTheme.Colors.textSecondary)
                                .padding(.horizontal, AppTheme.Spacing.medium)
                                .shadow(radius: AppTheme.Shadows.small)
                                .font(AppTheme.Typography.bodyFont)
                            
                            // Interactive volcano diagram
                            ZStack {
                                // Volcano illustration
                                VStack(spacing: 0) {
                                    // Ash cloud area
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 60)
                                    
                                    // Mountain shape
                                    Triangle()
                                        .fill(Color.brown.opacity(0.8))
                                        .frame(width: 280, height: 180)
                                        .overlay(
                                            // Crater
                                            Ellipse()
                                                .fill(Color.red.opacity(0.9))
                                                .frame(width: 50, height: 25)
                                                .offset(y: -77)
                                                .shadow(color: .red, radius: pulseAnimation ? 10 : 5)
                                                .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                                        )
                                    
                                    // Base/underground
                                    Rectangle()
                                        .fill(Color.brown.opacity(0.6))
                                        .frame(width: 280, height: 80)
                                }
                                .onAppear {
                                    showInteractiveVolcano = true
                                    // Pulse animation for crater
                                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                        pulseAnimation = true
                                    }
                                }
                                
                                // Interactive hotspots
                                ForEach(Array(volcanoParts.enumerated()), id: \.element.id) { index, part in
                                    Button(action: {
                                        selectedPart = part
                                        showPartsInfo = true
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.yellow.opacity(0.8))
                                                .frame(width: 30, height: 30)
                                                .shadow(color: .yellow, radius: 8)
                                                .scaleEffect(selectedPart?.id == part.id ? 1.3 : 1.0)
                                            
                                            Text(part.emoji)
                                                .font(.title3)
                                        }
                                    }
                                    .position(part.position)
                                    .opacity(showInteractiveVolcano ? 1.0 : 0.0)
                                    .scaleEffect(showInteractiveVolcano ? 1.0 : 0.5)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(Double(index) * 0.2), value: showInteractiveVolcano)
                                    .animation(.easeInOut(duration: 0.3), value: selectedPart?.id)
                                }
                            }
                            .frame(height: 350)
                            .padding(.horizontal)
                            
                            // Information panel
                            if let selectedPart = selectedPart {
                                VStack(spacing: 15) {
                                    HStack {
                                        Text(selectedPart.emoji)
                                            .font(.title)
                                        Text(selectedPart.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(selectedPart.description)
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .padding(.all, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.2))
                                        .shadow(radius: 10)
                                )
                                .padding(.horizontal, 20)
                                .transition(.scale.combined(with: .opacity))
                            } else {
                                VStack(spacing: 10) {
                                    Text("🔍")
                                        .font(.title)
                                    Text("Tap the glowing dots to learn about each volcano part!")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30)
                                }
                                .padding(.vertical, 20)
                            }
                            
                            // Fun facts section
                            VStack(spacing: 15) {
                                Text("🌟 Fun Volcano Facts!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 10) {
                                    factCard("🌡️", "Lava can be as hot as 1,200°C - that's hotter than your oven!")
                                    factCard("🏔️", "Some volcanoes are taller than the clouds!")
                                    factCard("🌍", "There are about 1,500 active volcanoes in the world!")
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // Bottom completion section
                            VStack(spacing: 15) {
                                Text("🎉 Congratulations! 🎉")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    celebrateCompletion()
                                }) {
                                    HStack {
                                        Text("🎓")
                                            .scaleEffect(celebrationScale)
                                        Text("You Finished this Application!")
                                            .fontWeight(.bold)
                                            .scaleEffect(celebrationScale)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 25)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(showCelebration ? Color.green.opacity(0.8) : Color.blue.opacity(0.8))
                                            .shadow(radius: 10)
                                    )
                                }
                                .scaleEffect(celebrationScale)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 30)
                            
                            Spacer().frame(height: 30)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
                // Celebration confetti overlay
                if showConfetti {
                    ConfettiView()
                        .allowsHitTesting(false)
                }
            }
            .animation(.easeInOut, value: selectedPart?.id)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Helper function for fact cards
    private func factCard(_ emoji: String, _ text: String) -> some View {
        HStack(spacing: 10) {
            Text(emoji)
                .font(.title2)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.all, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.15))
        )
    }
    
    private func celebrateCompletion() {
        showCelebration = true
        showConfetti = true
        
        // Scale animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            celebrationScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                celebrationScale = 1.0
            }
        }
        
        // Hide confetti after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut) {
                showConfetti = false
            }
        }
        
        // Call the original unlock function
        takeALookAndUnlockNextPage()
    }
    
    private func takeALookAndUnlockNextPage() {
        if let nextIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < viewModel.pages.count {
                viewModel.unlockPage(viewModel.pages[nextPageIndex].id)
            }
        }
        // Add any additional navigation logic here
    }
}

// Confetti Animation View
struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<50) { i in
                    Circle()
                        .fill(Color.random)
                        .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: animate ? geometry.size.height + 50 : -50
                        )
                        .animation(
                            .linear(duration: Double.random(in: 2...4))
                            .delay(Double.random(in: 0...1)),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
}

// Extension for random colors
extension Color {
    static var random: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

// Supporting structs
struct VolcanoPart: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let position: CGPoint
    let emoji: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: VolcanoPart, rhs: VolcanoPart) -> Bool {
        lhs.id == rhs.id
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    DetailView3(viewModel: PageViewModel(), pageId: 3)
}
