import SwiftUI
import Foundation

/// ViewModel for DetailView3 (Parts of Volcano page)
class DetailView3ViewModel: ObservableObject {
    @Published var currentSection: Int = 0 // 0 = educational, 1 = quiz
    
    private let pageViewModel: PageViewModel
    private let pageId: Int
    
    init(pageViewModel: PageViewModel, pageId: Int) {
        self.pageViewModel = pageViewModel
        self.pageId = pageId
    }
    
    func switchToQuiz() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            currentSection = 1
        }
    }
    
    func switchToEducational() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            currentSection = 0
        }
    }
    
    func unlockNextPage() {
        if let nextIndex = pageViewModel.pages.firstIndex(where: { $0.id == pageId }) {
            let nextPageIndex = nextIndex + 1
            if nextPageIndex < pageViewModel.pages.count {
                pageViewModel.unlockPage(pageViewModel.pages[nextPageIndex].id)
            }
        }
    }
}

