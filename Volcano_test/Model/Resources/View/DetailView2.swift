import SwiftUI

struct DetailView2: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int
    @State private var textStage = 0
    @State private var showUnlockNextPageButton = false
    @State private var isPageAlreadyUnlocked = false
    @State private var isNavigating = false
    @Environment(\.presentationMode) var presentationMode
    
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
                
                Text("What is volcano?")
                    .font(AppTheme.Typography.pageTitleFont)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .shadow(radius: AppTheme.Shadows.medium)
                
                Group {
                    if textStage >= 1 {
                        storyText("a volcano is an opening in the Earth's surface.").padding()
                    }
                    if textStage >= 2 {
                        storyText("Some volcanoes sleep for a long, long time, while others wake up and erupt!").padding()
                    }
                    if textStage >= 3 {
                        storyText("When a volcano erupts, it looks like a fireworks show but with lava and ash instead of lights. ").padding()
                    }
                    if textStage >= 4 {
                        storyText("There are many volcanoes in the world, and we can learn about them together! \n Do you want to learn?  ")
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    if !isPageAlreadyUnlocked {
                                        showUnlockNextPageButton = true
                                    }
                                }
                            }
                    }
                }
                
                Spacer()
                
                if textStage < 4 {
                    actionButton(image: "arrow.right.circle.fill", color: .orange) {
                        textStage += 1
                    }
                }
                
                if showUnlockNextPageButton || isPageAlreadyUnlocked {
                    Button(action: {
                        unlockNextPage()
                        DispatchQueue.main.asyncAfter(deadline: .now() + AppTheme.Animation.defaultDuration) {
                            isNavigating = true
                        }
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

                NavigationLink(destination: PuzzleListView(), isActive: $isNavigating) {
                    EmptyView()
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: textStage)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            checkIfPageAlreadyUnlocked()
        }
    }
    
    private func storyText(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .foregroundColor(AppTheme.Colors.textSecondary)
            .padding(.horizontal, AppTheme.Spacing.medium)
            .transition(.opacity)
            .shadow(radius: AppTheme.Shadows.small)
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
    
    private func unlockNextPage() {
        if let nextIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < viewModel.pages.count {
                viewModel.unlockPage(viewModel.pages[nextPageIndex].id)
                isPageAlreadyUnlocked = true
                showUnlockNextPageButton = false
            }
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
    DetailView2(viewModel: PageViewModel(), pageId: 2)
}
