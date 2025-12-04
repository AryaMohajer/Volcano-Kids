import SwiftUI
import AVFoundation

struct PageItemView: View {
    let page: PageModel
    @ObservedObject var viewModel: PageViewModel

    var body: some View {
        ZStack {
   
            NavigationLink(destination: destinationView(for: page.id)) {
                Image(imageName(for: page.id))
                    .resizable()
                    .scaledToFill()
                    .frame(width: AppTheme.Sizes.cardWidth, height: AppTheme.Sizes.cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card))
                    .shadow(
                        color: page.isUnlocked ? .black.opacity(0.3) : .clear,
                        radius: AppTheme.Shadows.medium,
                        x: 5,
                        y: 5
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                            .stroke(
                                page.isUnlocked ? AppTheme.Colors.border : Color.clear,
                                lineWidth: 3
                            )
                    )
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card)
                            .fill(AppTheme.Colors.cardBackground)
                            .shadow(
                                color: page.isUnlocked ? AppTheme.Colors.primaryBackground.opacity(0.5) : Color.clear,
                                radius: AppTheme.Shadows.medium,
                                x: 0,
                                y: 5
                            )
                    )
                    .grayscale(page.isUnlocked ? 0 : 0.8)
                    .opacity(page.isUnlocked ? 1 : 0.5)
                    .animation(.easeInOut, value: page.isUnlocked)
            }
            
            if !page.isUnlocked {
                AppTheme.Colors.overlay
                    .frame(width: AppTheme.Sizes.cardWidth, height: AppTheme.Sizes.cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.card))

                Image(systemName: "lock.fill")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        // Audio is now managed at app level, no need to play here

    }
    
    /// Get the correct image name based on page id
    private func imageName(for id: Int) -> String {
        switch id {
        case 4:
            return "Types Of Volcanoes"
        case 5:
            return "Famouse Volcanoes" // Note: matches the imageset name (typo in asset name)
        case 6:
            return "Volcano Safety Tips"
        case 7:
            return "Volcano Rocks"
        default:
            // For pages 1, 2, 3, use the original naming convention
            return "image\(id)"
        }
    }

    @ViewBuilder
    private func destinationView(for id: Int) -> some View {
        switch id {
        case 1: DetailView1(viewModel: viewModel, pageId: id)
        case 2: DetailView2(viewModel: viewModel, pageId: id)
        case 3: DetailView3(viewModel: viewModel, pageId: id)
        case 4: DetailView4(viewModel: viewModel, pageId: id)
        case 5: DetailView5(viewModel: viewModel, pageId: id)
        case 6: DetailView6(viewModel: viewModel, pageId: id)
        case 7: DetailView7(viewModel: viewModel, pageId: id)
        default: Text("Page Not Found")
        }
    }
}



