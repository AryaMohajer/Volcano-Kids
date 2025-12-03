import SwiftUI
import SceneKit

struct ModelView: View {
    @StateObject private var viewModel = ModelView3D()
    @Environment(\.presentationMode) var presentationMode
    let modelName: String = "abc"
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 5)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 20)
                
                VStack {
                    SceneKitView(scene: viewModel.scene)
                        .background(Color.black)
                        .frame(width: 400, height: 400)
                        .onAppear {
                            print("🔵 Loading model: \(modelName).usdz")
                            viewModel.loadModel(named: modelName)
                                
                        }
                                   
                                   Text("Wow! Can you believe that a very, very long time ago, our planet looked like this!")
                        .font(.custom("Noteworthy-Bold", size: 20))
                                       .foregroundColor(.red)
                                       .multilineTextAlignment(.center)
                                       .padding()
                               }
                              // .background(Color.black.ignoresSafeArea())
                            
                                
                        
               
            }
        }
    }
}
