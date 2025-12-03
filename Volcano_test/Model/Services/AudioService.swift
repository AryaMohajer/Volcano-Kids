import AVFoundation
import Foundation

/// Centralized audio service for managing background music
@MainActor
class AudioService: ObservableObject {
    static let shared = AudioService()
    
    // Use nonisolated(unsafe) to allow access from deinit
    nonisolated(unsafe) private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Error setting up audio session: \(error.localizedDescription)")
        }
    }
    
    /// Play background music (loops infinitely)
    func playBackgroundMusic() {
        // Don't restart if already playing
        guard !isPlaying else { return }
        
        guard let url = Bundle.main.url(
            forResource: AppConstants.Audio.backgroundMusicFileName,
            withExtension: AppConstants.Audio.backgroundMusicFileExtension
        ) else {
            print("❌ Error: Audio file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Infinite loop
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("❌ Error: Unable to play the audio file. \(error.localizedDescription)")
            isPlaying = false
        }
    }
    
    /// Stop background music
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    /// Pause background music
    func pauseBackgroundMusic() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    /// Resume background music
    func resumeBackgroundMusic() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    nonisolated deinit {
        // Directly stop the audio player - safe because audioPlayer is nonisolated(unsafe)
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

