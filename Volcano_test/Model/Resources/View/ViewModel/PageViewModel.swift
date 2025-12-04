import SwiftUI

class PageViewModel: ObservableObject {
    @Published var pages: [PageModel] = []
    private let persistenceService: PersistenceServiceProtocol
    
    init(persistenceService: PersistenceServiceProtocol = PersistenceService.shared) {
        self.persistenceService = persistenceService
        loadPages()
    }
    
    func loadPages() {
        // For testing: unlock all pages by default
        // Reordered: What Is Volcano? first, then Parts Of A Volcano, then History Of Earth
        pages = [
            PageModel(id: 2, title: "What Is Volcano?", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(2)),
            PageModel(id: 3, title: "Parts Of A Volcano", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(3)),
            PageModel(id: 1, title: "History Of Earth", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(1)),
            PageModel(id: 4, title: "Types Of Volcanoes", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(4)),
            PageModel(id: 5, title: "Famous Volcanoes", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(5)),
            PageModel(id: 6, title: "Volcano Safety Tips", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(6)),
            PageModel(id: 7, title: "Volcano Rocks & Minerals", isUnlocked: true, isCompleted: persistenceService.isPageCompleted(7)),
            PageModel(id: 8, title: "Settings", isUnlocked: true, isCompleted: false) // Settings is never "completed"
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
    
    func completePage(_ id: Int) {
        if let index = pages.firstIndex(where: { $0.id == id }) {
            pages[index].isCompleted = true
            persistenceService.completePage(id)
        }
    }
}
