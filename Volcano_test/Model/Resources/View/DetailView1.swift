import SwiftUI
import RealityKit
import SceneKit

struct DetailView1: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @State private var textStage = 0
    @State private var isPageAlreadyUnlocked = false
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToNextPage = false
    @StateObject private var modelView = ModelView3D()
    @State private var showModelView = false
    @State private var showUnlockNextPageButton = false
    
    var body: some View {
        ZStack {
            AppTheme.Colors.primaryBackground
                .ignoresSafeArea()
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .cornerRadius(AppTheme.CornerRadius.medium)
                .shadow(radius: AppTheme.Shadows.small)
                .frame(width: 370, height: 780)
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.leading, 10)
                
                Text("History of Earth")
                    .font(AppTheme.Typography.pageTitleFont)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .shadow(radius: AppTheme.Shadows.medium)
                
                Spacer().frame(height: 10)
                
                Group {
                    if textStage >= 1 {
                        storyText("A long time ago, Earth was very different. It was super hot! Giant volcanoes exploded with fire and smoke, and the sky was dark with big black clouds.").padding()
                    }
                    if textStage >= 2 {
                        storyText("There were no trees, no rivers, and no animals just fire, and red-hot rocks everywhere").padding()
                    }
                    if textStage >= 3 {
                        storyText("Everything was super hot, with no cool place to rest. The ground was burning, and the whole Earth was bright red!").padding()
                    }
                    if textStage >= 4 {
                        storyText("Do you want to see Earth when it was like that?")
                    }
                   
                }
                
                Spacer()
                
                if textStage < 4 {
                    actionButton(image: "arrow.right.circle.fill", color: .orange) {
                        textStage += 1
                    }
                } else {
                    Button(action: {
                        takeALookAndUnlockNextPage()
                    }) {
                        Text("Yes sure!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .frame(width: AppTheme.Sizes.buttonWidth, height: AppTheme.Sizes.buttonHeight)
                            .background(AppTheme.Colors.accent)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                            .shadow(radius: AppTheme.Shadows.medium)
                    }
                 
                }
                
                Spacer().frame(height: 20)
            }
            .padding()
        }
        .animation(.easeInOut, value: textStage)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            checkIfPageAlreadyUnlocked()
        }
        .background(
            NavigationLink(destination: ModelView().navigationBarBackButtonHidden(true), isActive: $navigateToNextPage) {
                EmptyView()
            }
        )
    }
        

    private func storyText(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .foregroundColor(AppTheme.Colors.textSecondary)
            .padding(-5)
    }
    
    private func actionButton(image: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: image)
                .resizable()
                .frame(width: AppTheme.Sizes.iconSize, height: AppTheme.Sizes.iconSize)
                .foregroundColor(color.opacity(0.9))
                .background(AppTheme.Colors.cardBackground.clipShape(Circle()))
                .shadow(radius: AppTheme.Shadows.medium)
                .padding()
        }
    }
    
    private func takeALookAndUnlockNextPage() {
        if let nextIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < viewModel.pages.count {
                viewModel.unlockPage(viewModel.pages[nextPageIndex].id)
                isPageAlreadyUnlocked = true
                showUnlockNextPageButton = false
            }
        }
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            navigateToNextPage = true
        }
    }
    
    private func checkIfPageAlreadyUnlocked() {
        if let nextIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < viewModel.pages.count {
                isPageAlreadyUnlocked = viewModel.pages[nextPageIndex].isUnlocked
            }
        }
    }
}

#Preview {
    DetailView1(viewModel: PageViewModel(), pageId: 1)
}
