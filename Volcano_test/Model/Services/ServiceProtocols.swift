import Foundation
import AVFoundation

// MARK: - Persistence Service Protocol
protocol PersistenceServiceProtocol {
    func unlockPage(_ id: Int)
    func isPageUnlocked(_ id: Int) -> Bool
    func resetProgress()
    func completePage(_ id: Int)
    func isPageCompleted(_ id: Int) -> Bool
}

// MARK: - Audio Service Protocol
protocol AudioServiceProtocol {
    func playBackgroundMusic()
    func stopBackgroundMusic()
    func pauseBackgroundMusic()
    func resumeBackgroundMusic()
}

// MARK: - Persistence Service Implementation
extension PersistenceService: PersistenceServiceProtocol {
    // Implementation already exists in PersistenceService
}

// MARK: - Audio Service Implementation
extension AudioService: AudioServiceProtocol {
    // Implementation already exists in AudioService
}

