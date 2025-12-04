import UIKit
import SwiftUI

/// Service for managing haptic feedback
class HapticService {
    static let shared = HapticService()
    
    private init() {}
    
    /// Trigger light haptic feedback
    func lightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Trigger medium haptic feedback
    func mediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Trigger heavy haptic feedback
    func heavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    /// Trigger success notification haptic
    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Trigger error notification haptic
    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    /// Trigger warning notification haptic
    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Trigger haptic feedback if enabled
    func triggerIfEnabled(_ type: HapticType, isEnabled: Bool) {
        guard isEnabled else { return }
        
        switch type {
        case .light:
            lightImpact()
        case .medium:
            mediumImpact()
        case .heavy:
            heavyImpact()
        case .success:
            success()
        case .error:
            error()
        case .warning:
            warning()
        }
    }
}

enum HapticType {
    case light
    case medium
    case heavy
    case success
    case error
    case warning
}

