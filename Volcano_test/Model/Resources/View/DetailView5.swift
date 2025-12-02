import SwiftUI

struct DetailView5: View {
    @ObservedObject var viewModel: PageViewModel
    let pageId: Int  // Store current page ID

    var body: some View {
        VStack {
            Image("coders")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 400)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
                .shadow(radius: AppTheme.Shadows.medium)
                .padding()

            Text("Welcome to Page \(pageId)")
                .font(.largeTitle)
                .bold()
                .padding(.top, AppTheme.Spacing.small)

            Text("This is a detailed view for **Page \(pageId)**. Here you can add more information about the page content.")
                .font(AppTheme.Typography.bodyFont)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            // Unlock Next Page Button
            Button("Unlock Next Page") {
                unlockNextPage()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, AppTheme.Spacing.medium)
            .disabled(!canUnlockNextPage())  // Disable if the next page is already unlocked
        }
        .navigationTitle("Detail View \(pageId)")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Unlocks only the next immediate page
    private func unlockNextPage() {
        if let nextIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < viewModel.pages.count {
                viewModel.unlockPage(viewModel.pages[nextPageIndex].id)
            }
        }
    }

    /// Checks if the next page can be unlocked
    private func canUnlockNextPage() -> Bool {
        if let currentIndex = viewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = currentIndex + 1
            return nextPageIndex < viewModel.pages.count && !viewModel.pages[nextPageIndex].isUnlocked
        }
        return false
    }
}

#Preview {
    DetailView2(viewModel: PageViewModel(), pageId: 5)
}
