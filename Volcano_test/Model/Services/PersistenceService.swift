import Foundation

/// Service for persisting app state
class PersistenceService {
    static let shared = PersistenceService()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Page Unlock State
    
    /// Save unlocked pages
    func saveUnlockedPages(_ pageIds: Set<Int>) {
        let array = Array(pageIds)
        userDefaults.set(array, forKey: AppConstants.UserDefaultsKeys.unlockedPages)
    }
    
    /// Load unlocked pages
    func loadUnlockedPages() -> Set<Int> {
        guard let array = userDefaults.array(forKey: AppConstants.UserDefaultsKeys.unlockedPages) as? [Int] else {
            return [1] // First page is always unlocked
        }
        return Set(array)
    }
    
    /// Check if a page is unlocked
    func isPageUnlocked(_ pageId: Int) -> Bool {
        let unlocked = loadUnlockedPages()
        return unlocked.contains(pageId)
    }
    
    /// Unlock a page
    func unlockPage(_ pageId: Int) {
        var unlocked = loadUnlockedPages()
        unlocked.insert(pageId)
        saveUnlockedPages(unlocked)
    }
    
    // MARK: - Page Completion State
    
    /// Save completed pages
    func saveCompletedPages(_ pageIds: Set<Int>) {
        let array = Array(pageIds)
        userDefaults.set(array, forKey: "completedPages")
    }
    
    /// Load completed pages
    func loadCompletedPages() -> Set<Int> {
        guard let array = userDefaults.array(forKey: "completedPages") as? [Int] else {
            return []
        }
        return Set(array)
    }
    
    /// Check if a page is completed
    func isPageCompleted(_ pageId: Int) -> Bool {
        let completed = loadCompletedPages()
        return completed.contains(pageId)
    }
    
    /// Mark a page as completed
    func completePage(_ pageId: Int) {
        var completed = loadCompletedPages()
        completed.insert(pageId)
        saveCompletedPages(completed)
    }
    
    /// Reset all progress (for testing/debugging)
    func resetProgress() {
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.unlockedPages)
        userDefaults.removeObject(forKey: "completedPages")
    }
}

