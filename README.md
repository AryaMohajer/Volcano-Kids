# 🌋 Volcano Kids

An educational iOS app for kids to learn about volcanoes through interactive stories, puzzles, and 3D models.

## Features

- 📚 **Educational Content**: Learn about Earth's history and volcanoes through engaging stories
- 🧩 **Interactive Puzzles**: Solve sliding puzzles featuring real volcanoes
- 🎨 **Beautiful Design**: Kid-friendly UI with animations and visual effects
- 🎵 **Background Music**: Immersive audio experience
- 💾 **Progress Tracking**: Unlock new content as you progress

## Architecture

The app follows modern iOS development best practices:

- **MVVM Architecture**: Clean separation of concerns
- **SwiftUI**: Modern declarative UI framework
- **Service Layer**: Centralized services for audio and persistence
- **Theme System**: Consistent design system with centralized constants

## Project Structure

```
Volcano_test/
├── Model/
│   ├── Theme.swift              # Centralized theme and constants
│   ├── Services/
│   │   ├── AudioService.swift   # Audio management
│   │   └── PersistenceService.swift  # Data persistence
│   └── Resources/View/
│       ├── ViewModel/           # View models
│       └── *.swift              # Views
```

## Requirements

- iOS 17.0+
- Xcode 16.3+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `Volcano Kids.xcodeproj` in Xcode
3. Build and run on simulator or device

## Recent Improvements

- ✅ Fixed deployment target (iOS 17.0)
- ✅ Implemented data persistence for unlock states
- ✅ Refactored audio service with proper lifecycle management
- ✅ Created centralized theme system
- ✅ Fixed memory leaks and performance issues
- ✅ Improved error handling
- ✅ Standardized naming conventions

## License

Copyright © 2025

