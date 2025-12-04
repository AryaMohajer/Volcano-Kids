import SwiftUI
import Foundation

/// ViewModel for Settings page
class SettingsViewModel: ObservableObject {
    @Published var isHapticEnabled: Bool = true {
        didSet {
            UserDefaults.standard.set(isHapticEnabled, forKey: "isHapticEnabled")
            // Test haptic feedback when enabled
            if isHapticEnabled {
                HapticService.shared.mediumImpact()
            }
        }
    }
    
    @Published var showResetConfirmation: Bool = false
    @Published var selectedTheme: AppThemeType = .default {
        didSet {
            ThemeManager.shared.setTheme(selectedTheme)
            if isHapticEnabled {
                HapticService.shared.lightImpact()
            }
        }
    }
    
    private let persistenceService: PersistenceServiceProtocol
    
    init(persistenceService: PersistenceServiceProtocol = PersistenceService.shared) {
        self.persistenceService = persistenceService
        loadSettings()
    }
    
    private func loadSettings() {
        isHapticEnabled = UserDefaults.standard.bool(forKey: "isHapticEnabled", defaultValue: true)
        selectedTheme = ThemeManager.shared.currentTheme
    }
    
    func resetProgress() {
        persistenceService.resetProgress()
        // Reset all pages except the first one
        UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultsKeys.unlockedPages)
    }
    
    func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }
}

// MARK: - UserDefaults Extension
extension UserDefaults {
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if object(forKey: key) == nil {
            return defaultValue
        }
        return bool(forKey: key)
    }
}

