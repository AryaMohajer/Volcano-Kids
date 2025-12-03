import SwiftUI

struct DetailView4: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Red background
            AppTheme.Colors.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Title
                Text("Meet the Volcano Family!")
                    .font(.custom("Noteworthy-Bold", size: 36))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                
                // Large white content card
                ScrollView {
                    VStack(spacing: 0) {
                        // Main illustration at top
                        VolcanoTypesIllustration()
                            .padding(.top, 20)
                            .padding(.bottom, 25)
                        
                        // Three volcano types
                        VolcanoTypeSection(
                            icon: "🛡️",
                            title: "Shield Volcano",
                            description: "Shield volcanoes are wide and flat, like a pancake! They are made from many layers of thin, runny lava that flows slowly and spreads far. Think of them as the gentle giants of volcanoes.",
                            characteristics: ["Very wide and flat", "Made from runny lava", "Gentle slopes", "Can be huge!"],
                            example: "Mauna Loa in Hawaii"
                        )
                        
                        Divider()
                            .padding(.vertical, 15)
                        
                        VolcanoTypeSection(
                            icon: "🗻",
                            title: "Composite Volcano",
                            description: "Composite volcanoes are tall and pointy, like an ice cream cone! They are made from layers of lava and ash that build up over time. They can be very dangerous when they erupt!",
                            characteristics: ["Tall and pointy", "Made from lava and ash", "Steep sides", "Can erupt explosively!"],
                            example: "Mount Fuji in Japan"
                        )
                        
                        Divider()
                            .padding(.vertical, 15)
                        
                        VolcanoTypeSection(
                            icon: "🏔️",
                            title: "Cinder Cone",
                            description: "Cinder cone volcanoes are small and steep! They look like a perfect cone made from cinders and ash. They are the smallest type of volcano, but still very powerful!",
                            characteristics: ["Small and steep", "Made from cinders", "Perfect cone shape", "Usually short-lived"],
                            example: "Parícutin in Mexico"
                        )
                        
                        Spacer()
                            .frame(height: 30)
                    }
                    .padding(.horizontal, 20)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(radius: 10)
                )
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Volcano Types Illustration
struct VolcanoTypesIllustration: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Three Types of Volcanoes")
                .font(.custom("Noteworthy-Bold", size: 24))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            
            HStack(spacing: 20) {
                // Shield Volcano
                VStack(spacing: 8) {
                    ZStack {
                        // Wide flat shape
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [.brown.opacity(0.6), .brown.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 80, height: 30)
                        
                        Text("🛡️")
                            .font(.system(size: 30))
                    }
                    Text("Shield")
                        .font(.custom("Noteworthy-Bold", size: 14))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
                
                // Composite Volcano
                VStack(spacing: 8) {
                    ZStack {
                        // Tall pointy shape
                        Triangle()
                            .fill(
                                LinearGradient(
                                    colors: [.brown.opacity(0.7), .brown.opacity(0.5)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 40, height: 50)
                        
                        Text("🗻")
                            .font(.system(size: 30))
                            .offset(y: -10)
                    }
                    Text("Composite")
                        .font(.custom("Noteworthy-Bold", size: 14))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
                
                // Cinder Cone
                VStack(spacing: 8) {
                    ZStack {
                        // Small cone shape
                        Triangle()
                            .fill(
                                LinearGradient(
                                    colors: [.brown.opacity(0.8), .brown.opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 35, height: 40)
                        
                        Text("🏔️")
                            .font(.system(size: 25))
                            .offset(y: -8)
                    }
                    Text("Cinder")
                        .font(.custom("Noteworthy-Bold", size: 14))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
            }
        }
    }
}

// MARK: - Volcano Type Section
struct VolcanoTypeSection: View {
    let icon: String
    let title: String
    let description: String
    let characteristics: [String]
    let example: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header with icon
            HStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 40))
                
                Text(title)
                    .font(.custom("Noteworthy-Bold", size: 28))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
            
            // Description
            Text(description)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // Characteristics
            VStack(alignment: .leading, spacing: 8) {
                Text("Key Features:")
                    .font(.custom("Noteworthy-Bold", size: 20))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                ForEach(characteristics, id: \.self) { characteristic in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        Text(characteristic)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                }
            }
            
            // Example
            HStack(spacing: 8) {
                Text("📍")
                    .font(.system(size: 18))
                Text("Example: \(example)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.0))
                    .italic()
            }
            .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Triangle Shape
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
    DetailView4(viewModel: PageViewModel(), pageId: 4)
}
