import SwiftUI

struct VolcanoPartsView: View {
    @State private var userAnswers: [String] = Array(repeating: "", count: 5)
    @State private var showCorrectAnswers = false
    
    let volcanoParts = ["Crater", "Magma Chamber", "Vent", "Lava Flow", "Ash Cloud"]
    let explanations = [
        "The bowl-shaped opening at the top of the volcano.",
        "A large underground pool of molten rock.",
        "A channel through which magma travels to the surface.",
        "Molten rock that flows out of the volcano during an eruption.",
        "A cloud of ash released into the air during an eruption."
    ]
    
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.red, Color.orange]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
                .frame(height: 100)
            
            VStack {
                ForEach(0..<5, id: \.self) { index in
                    HStack {
                        TextField("Type part name", text: $userAnswers[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                        
                        Text(explanations[index])
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            
            Image("VolcanoParts")
                .resizable()
                .scaledToFit()
                .padding()
            
            Button(action: {
                showCorrectAnswers.toggle()
                if showCorrectAnswers {
                    for i in 0..<userAnswers.count {
                        userAnswers[i] = volcanoParts[i]
                    }
                }
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200)
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
            .padding(.top, 20)
        }
        .navigationTitle("Volcano Parts")
    }
}

#Preview {
    VolcanoPartsView()
}
