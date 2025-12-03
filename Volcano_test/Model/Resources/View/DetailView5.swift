import SwiftUI

struct DetailView5: View {
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
                Text("World Tour of Hot Spots!")
                    .font(.custom("Noteworthy-Bold", size: 36))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                
                // Large white content card
                ScrollView {
                    VStack(spacing: 0) {
                        // Main illustration at top
                        WorldMapIllustration()
                            .padding(.top, 20)
                            .padding(.bottom, 25)
                        
                        // Three famous volcanoes
                        FamousVolcanoSection(
                            flag: "🇯🇵",
                            title: "Mount Fuji",
                            location: "Japan",
                            description: "Mount Fuji is Japan's tallest and most famous volcano! It's a perfect cone shape and is considered sacred. It last erupted in 1707, but it's still an active volcano!",
                            funFact: "Mount Fuji is a UNESCO World Heritage Site and is featured in many Japanese artworks!",
                            height: "3,776 meters"
                        )
                        
                        Divider()
                            .padding(.vertical, 15)
                        
                        FamousVolcanoSection(
                            flag: "🇮🇹",
                            title: "Mount Vesuvius",
                            location: "Italy",
                            description: "Mount Vesuvius is famous for destroying the ancient city of Pompeii in 79 AD! It's one of the most dangerous volcanoes in the world because millions of people live nearby.",
                            funFact: "Mount Vesuvius is the only active volcano on mainland Europe!",
                            height: "1,281 meters"
                        )
                        
                        Divider()
                            .padding(.vertical, 15)
                        
                        FamousVolcanoSection(
                            flag: "🇺🇸",
                            title: "Kīlauea",
                            location: "Hawaii, USA",
                            description: "Kīlauea is one of the most active volcanoes in the world! It's a shield volcano that creates beautiful, slow-moving lava flows. People can safely watch the lava flow!",
                            funFact: "Kīlauea has been erupting almost continuously since 1983!",
                            height: "1,247 meters"
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

// MARK: - World Map Illustration
struct WorldMapIllustration: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Famous Volcanoes Around the World")
                .font(.custom("Noteworthy-Bold", size: 24))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            
            // Simple world map representation
            HStack(spacing: 30) {
                // Japan
                VStack(spacing: 5) {
                    Text("🇯🇵")
                        .font(.system(size: 40))
                    Text("Japan")
                        .font(.custom("Noteworthy-Bold", size: 16))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
                
                // Italy
                VStack(spacing: 5) {
                    Text("🇮🇹")
                        .font(.system(size: 40))
                    Text("Italy")
                        .font(.custom("Noteworthy-Bold", size: 16))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
                
                // Hawaii
                VStack(spacing: 5) {
                    Text("🇺🇸")
                        .font(.system(size: 40))
                    Text("Hawaii")
                        .font(.custom("Noteworthy-Bold", size: 16))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
            )
        }
    }
}

// MARK: - Famous Volcano Section
struct FamousVolcanoSection: View {
    let flag: String
    let title: String
    let location: String
    let description: String
    let funFact: String
    let height: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header with flag
            HStack(spacing: 12) {
                Text(flag)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("Noteworthy-Bold", size: 28))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text(location)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
            }
            
            // Description
            Text(description)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // "Did You Know?" Box
            HStack(alignment: .top, spacing: 10) {
                Text("💡")
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Did You Know?")
                        .font(.custom("Noteworthy-Bold", size: 20))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    Text(funFact)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 1.0, green: 0.95, blue: 0.8))
            )
            
            // Height info
            HStack(spacing: 8) {
                Text("📏")
                    .font(.system(size: 18))
                Text("Height: \(height)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.0))
            }
            .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DetailView5(viewModel: PageViewModel(), pageId: 5)
}
