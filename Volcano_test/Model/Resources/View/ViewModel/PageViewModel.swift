import SwiftUI

class PageViewModel: ObservableObject {
    @Published var pages: [PageModel] = []
    private let persistenceService = PersistenceService.shared
    
    init() {
        loadPages()
    }
    
    private func loadPages() {
        // For testing: unlock all pages by default
        pages = [
            PageModel(id: 1, title: "History Of Earth", isUnlocked: true),
            PageModel(id: 2, title: "What Is Volcano?", isUnlocked: true),
            PageModel(id: 3, title: "Parts Of A Volcano", isUnlocked: true),
            PageModel(id: 4, title: "Types Of Volcanoes", isUnlocked: true),
            PageModel(id: 5, title: "Famous Volcanoes", isUnlocked: true)
        ]
        
        // Unlock all pages in persistence for testing
        for page in pages {
            persistenceService.unlockPage(page.id)
        }
    }
    
    func unlockPage(_ id: Int) {
        if let index = pages.firstIndex(where: { $0.id == id }) {
            pages[index].isUnlocked = true
            persistenceService.unlockPage(id)
        }
    }
}
