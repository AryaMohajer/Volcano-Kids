import SwiftUI
struct MergedPageView: View {
    @StateObject private var viewModel = PageViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.pages) { page in
                        PageItemView(page: page, viewModel: viewModel)
                            .disabled(!page.isUnlocked)
                    }
                }
                .padding(.horizontal, 16)
                .scrollIndicators(.hidden)
                .applyPagingIfAvailable()
            }
            .frame(height: 400)
        }
        .navigationBarBackButtonHidden(true)
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
}

