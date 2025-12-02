//
//  Volcano_testApp.swift
//  Volcano_test
//
//  Created by Arya Mohajer on 27/05/25.
//

import SwiftUI

@main
struct Volcano_testApp: App {
    @StateObject private var audioService = AudioService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.font, AppTheme.Typography.bodyFont)
                .onAppear {
                    // Start background music when app launches
                    audioService.playBackgroundMusic()
                }
        }
    }
}
