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
    
    /// Reset all progress (for testing/debugging)
    func resetProgress() {
        userDefaults.removeObject(forKey: AppConstants.UserDefaultsKeys.unlockedPages)
    }
}

