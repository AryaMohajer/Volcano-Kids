import SwiftUI

/// Centralized theme and constants for the app
struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let primaryBackground = Color.red
        static let secondaryBackground = Color.orange
        static let accent = Color.orange
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.9)
        static let overlay = Color.black.opacity(0.6)
        static let cardBackground = Color.white
        static let border = Color(red: 1.0, green: 0.27, blue: 0.0)
        
        // Gradient colors
        static let gradientStart = Color.red.opacity(0.7)
        static let gradientEnd = Color.orange.opacity(0.7)
    }
    
    // MARK: - Typography
    struct Typography {
        static let appTitleFont = Font.custom("Noteworthy-Bold", size: 45)
        static let pageTitleFont = Font.custom("Noteworthy-Bold", size: 30)
        static let bodyFont = Font.custom("Noteworthy-Bold", size: 20)
        static let headlineFont = Font.headline
        static let subheadlineFont = Font.subheadline
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let cardPadding: CGFloat = 20
        static let screenPadding: CGFloat = 10
    }
    
    // MARK: - Sizes
    struct Sizes {
        static let cardWidth: CGFloat = 250
        static let cardHeight: CGFloat = 350
        static let buttonHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 150
        static let iconSize: CGFloat = 70
        static let puzzleTileSize: CGFloat = 80
        static let thumbnailSize: CGFloat = 80
        static let detailIconSize: CGFloat = 280  // Equal-sized icon for detail view
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
        static let card: CGFloat = 30
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small: CGFloat = 5
        static let medium: CGFloat = 10
        static let large: CGFloat = 15
    }
    
    // MARK: - Animation
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let longDuration: Double = 1.5
        static let typingInterval: Double = 0.3
    }
}

/// App-wide constants
struct AppConstants {
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let unlockedPages = "unlockedPages"
        static let hasPlayedMusic = "hasPlayedMusic"
    }
    
    // MARK: - Audio
    struct Audio {
        static let backgroundMusicFileName = "arya"
        static let backgroundMusicFileExtension = "mp3"
    }
    
    // MARK: - Image Names
    struct ImageNames {
        static let maunaLoa = "Mauna Loa"
        static let mountTambora = "Mount Tambora"
        static let mountErebus = "Mount Erebus"
        static let ojosDelSalado = "Ojos del Salado"
        static let pic5Pic = "Pic5Pic"
    }
}

