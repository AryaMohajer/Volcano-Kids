import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    @StateObject private var viewModel = PageViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
            ZStack {
                    AppTheme.Colors.primaryBackground
                        .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("Volcano Kids")
                            .font(AppTheme.Typography.appTitleFont)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                            .shadow(radius: AppTheme.Shadows.small)
                            .padding(.bottom, AppTheme.Spacing.medium)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { proxy in
                            HStack(spacing: -30) {
                                ForEach(viewModel.pages) { page in
                                    VStack {
                                        PageItemView(page: page, viewModel: viewModel)
                                            .id(page.id)
                                                .frame(width: geometry.size.width * 0.8)
                                        
                                        Text(page.title)
                                                .foregroundColor(AppTheme.Colors.textPrimary)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onAppear {
                                if let firstPage = viewModel.pages.first {
                                    proxy.scrollTo(firstPage.id, anchor: .leading)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: AppTheme.Animation.longDuration)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                .onAppear {
                    isAnimating = true
                    }
                }
            }
        }
    }
}
