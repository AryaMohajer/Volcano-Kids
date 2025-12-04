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
            RootView()
                .environment(\.font, AppTheme.Typography.bodyFont)
                .onAppear {
                    // Start background music when app launches
                    audioService.playBackgroundMusic()
                }
        }
    }
}

private struct RootView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            ContentView()
                .opacity(showSplash ? 0 : 1)
            
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showSplash = false
                }
            }
        }
    }
}
