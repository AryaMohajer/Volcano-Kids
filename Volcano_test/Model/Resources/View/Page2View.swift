import SwiftUI

struct MergedPageView: View {
    @StateObject private var viewModel = PageViewModel()
    
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    scrollableContent
                }
                .navigationBarBackButtonHidden(true)
            } else {
                NavigationView {
                    scrollableContent
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    private var scrollableContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.pages) { page in
                    PageItemView(page: page, viewModel: viewModel)
                        .disabled(!page.isUnlocked)
                }
            }
            .padding(.horizontal, 16)
            .hideScrollIndicatorsIfAvailable()
            .applyPagingIfAvailable()
        }
        .frame(height: 400)
    }
}

// ✅ Extension to conditionally apply paging if iOS 17 or later
extension View {
    @ViewBuilder
    func applyPagingIfAvailable() -> some View {
        if #available(iOS 17.0, *) {
            self.scrollTargetBehavior(.paging)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func hideScrollIndicatorsIfAvailable() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollIndicators(.hidden)
        } else {
            self
        }
    }
}
