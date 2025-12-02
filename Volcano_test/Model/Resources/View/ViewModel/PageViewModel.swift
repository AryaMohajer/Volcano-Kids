import SwiftUI

class PageViewModel: ObservableObject {
    @Published var pages: [PageModel] = []
    private let persistenceService = PersistenceService.shared
    
    init() {
        loadPages()
    }
    
    private func loadPages() {
        let unlockedPages = persistenceService.loadUnlockedPages()
        
        pages = [
            PageModel(id: 1, title: "History Of Earth", isUnlocked: unlockedPages.contains(1)),
            PageModel(id: 2, title: "What Is Volcano?", isUnlocked: unlockedPages.contains(2)),
            PageModel(id: 3, title: "Parts Of A Volcano", isUnlocked: unlockedPages.contains(3))
        ]
        
        // Ensure first page is always unlocked
        if !unlockedPages.contains(1) {
            persistenceService.unlockPage(1)
            if let index = pages.firstIndex(where: { $0.id == 1 }) {
                pages[index].isUnlocked = true
            }
        }
    }
    
    func unlockPage(_ id: Int) {
        if let index = pages.firstIndex(where: { $0.id == id }) {
            pages[index].isUnlocked = true
            persistenceService.unlockPage(id)
        }
    }
}
