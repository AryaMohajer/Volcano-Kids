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
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                      
                    }
                    Spacer()
                }
                .padding(.leading, 30)
                .padding(.top,-100)
                
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
