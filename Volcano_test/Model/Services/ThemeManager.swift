import SwiftUI
import Foundation

/// Theme Manager for app-wide theme switching
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppThemeType = .default
    
    private let themeKey = "selectedTheme"
    
    private init() {
        loadTheme()
    }
    
    private func loadTheme() {
        if let savedThemeRaw = UserDefaults.standard.string(forKey: themeKey),
           let savedTheme = AppThemeType(rawValue: savedThemeRaw) {
            currentTheme = savedTheme
        } else {
            // Default to Volcano Red if no saved theme
            currentTheme = .default
        }
    }
    
    func setTheme(_ theme: AppThemeType) {
        currentTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }
    
    var themeColors: ThemeColors {
        currentTheme.colors
    }
}

/// App Theme Types
enum AppThemeType: String, CaseIterable {
    case `default` = "default"
    case dark = "dark"
    case blue = "blue"
    case green = "green"
    
    var displayName: String {
        switch self {
        case .default: return "Volcano Red"
        case .dark: return "Dark Mode"
        case .blue: return "Ocean Blue"
        case .green: return "Forest Green"
        }
    }
    
    var emoji: String {
        switch self {
        case .default: return "🌋"
        case .dark: return "🌙"
        case .blue: return "🌊"
        case .green: return "🌲"
        }
    }
    
    var colors: ThemeColors {
        switch self {
        case .default:
            return ThemeColors(
                primaryBackground: Color.red,
                secondaryBackground: Color.orange,
                accent: Color.orange,
                textPrimary: Color.white,
                textSecondary: Color.white.opacity(0.9),
                overlay: Color.black.opacity(0.6),
                cardBackground: Color.white,
                border: Color(red: 1.0, green: 0.27, blue: 0.0),
                gradientStart: Color.red.opacity(0.7),
                gradientEnd: Color.orange.opacity(0.7),
                backgroundGradient: [
                    Color(red: 0.1, green: 0.0, blue: 0.2),
                    Color(red: 0.3, green: 0.0, blue: 0.1),
                    Color.red,
                    Color.orange.opacity(0.8)
                ]
            )
        case .dark:
            return ThemeColors(
                primaryBackground: Color(red: 0.1, green: 0.1, blue: 0.15),
                secondaryBackground: Color(red: 0.2, green: 0.2, blue: 0.25),
                accent: Color(red: 0.4, green: 0.4, blue: 0.5),
                textPrimary: Color.white,
                textSecondary: Color.white.opacity(0.85),
                overlay: Color.black.opacity(0.7),
                cardBackground: Color(red: 0.15, green: 0.15, blue: 0.2),
                border: Color(red: 0.5, green: 0.5, blue: 0.6),
                gradientStart: Color(red: 0.1, green: 0.1, blue: 0.15).opacity(0.7),
                gradientEnd: Color(red: 0.2, green: 0.2, blue: 0.25).opacity(0.7),
                backgroundGradient: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.15, blue: 0.2),
                    Color(red: 0.2, green: 0.2, blue: 0.25)
                ]
            )
        case .blue:
            return ThemeColors(
                primaryBackground: Color(red: 0.0, green: 0.4, blue: 0.8),
                secondaryBackground: Color(red: 0.2, green: 0.6, blue: 1.0),
                accent: Color(red: 0.3, green: 0.7, blue: 1.0),
                textPrimary: Color.white,
                textSecondary: Color.white.opacity(0.9),
                overlay: Color.black.opacity(0.5),
                cardBackground: Color.white,
                border: Color(red: 0.0, green: 0.5, blue: 1.0),
                gradientStart: Color(red: 0.0, green: 0.4, blue: 0.8).opacity(0.7),
                gradientEnd: Color(red: 0.2, green: 0.6, blue: 1.0).opacity(0.7),
                backgroundGradient: [
                    Color(red: 0.0, green: 0.1, blue: 0.3),
                    Color(red: 0.0, green: 0.2, blue: 0.4),
                    Color(red: 0.0, green: 0.4, blue: 0.8),
                    Color(red: 0.2, green: 0.6, blue: 1.0).opacity(0.8)
                ]
            )
        case .green:
            return ThemeColors(
                primaryBackground: Color(red: 0.0, green: 0.6, blue: 0.3),
                secondaryBackground: Color(red: 0.2, green: 0.8, blue: 0.4),
                accent: Color(red: 0.3, green: 0.9, blue: 0.5),
                textPrimary: Color.white,
                textSecondary: Color.white.opacity(0.9),
                overlay: Color.black.opacity(0.5),
                cardBackground: Color.white,
                border: Color(red: 0.0, green: 0.7, blue: 0.4),
                gradientStart: Color(red: 0.0, green: 0.6, blue: 0.3).opacity(0.7),
                gradientEnd: Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.7),
                backgroundGradient: [
                    Color(red: 0.0, green: 0.2, blue: 0.1),
                    Color(red: 0.0, green: 0.3, blue: 0.15),
                    Color(red: 0.0, green: 0.6, blue: 0.3),
                    Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.8)
                ]
            )
        }
    }
}

/// Theme Colors Structure
struct ThemeColors {
    let primaryBackground: Color
    let secondaryBackground: Color
    let accent: Color
    let textPrimary: Color
    let textSecondary: Color
    let overlay: Color
    let cardBackground: Color
    let border: Color
    let gradientStart: Color
    let gradientEnd: Color
    let backgroundGradient: [Color]
}

