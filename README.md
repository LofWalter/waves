# Neural Waves - iOS Music App

A beautiful iOS app for playing neural music designed to enhance focus, relaxation, and deep sleep.

## Features

### 🎵 Three Music Categories
- **Focus**: Enhance concentration and productivity with neural music designed for deep work
- **Relax**: Unwind and reduce stress with calming soundscapes
- **Deep Sleep**: Promote restful sleep with specially crafted sleep-inducing tracks

### 🎮 Advanced Player Controls
- **Infinite Mode**: Loop tracks continuously for uninterrupted sessions
- **Timing Mode**: Set specific durations (15, 30, 45, 60, 90, or 120 minutes)
- Real-time countdown timer for timing mode
- Play/pause/stop controls
- Beautiful, intuitive interface

### ❤️ Personal Music Collection
- Save favorite tracks to your personal collection
- Easy access to all saved music in one place
- Remove tracks from saved collection with swipe gestures

## Technical Architecture

### SwiftUI + MVVM
- Built entirely with SwiftUI for modern iOS development
- MVVM architecture with ObservableObject for state management
- Reactive UI updates using Combine framework

### Audio Engine
- AVAudioPlayer integration for high-quality audio playback
- Background audio session support
- Automatic loop handling for infinite mode
- Timer-based playback control for timing mode

### Data Models
- `MusicCategory`: Enum defining Focus, Relax, and Deep Sleep categories
- `MusicTrack`: Comprehensive track model with metadata
- `AudioManager`: Central audio playback and state management

## Project Structure

```
NeuralWaves/
├── Models/
│   ├── MusicCategory.swift    # Category definitions and metadata
│   └── MusicTrack.swift       # Track model and sample data
├── Views/
│   ├── CategoriesView.swift   # Page 1: Category selection
│   ├── PlayerView.swift       # Page 2: Music player
│   └── SavedMusicView.swift   # Page 3: Saved music collection
├── Managers/
│   └── AudioManager.swift     # Audio playback and state management
├── Assets.xcassets/           # App icons and colors
└── Preview Content/           # SwiftUI preview assets
```

## Getting Started

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `NeuralWaves.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device

### Sample Data
The app includes 9 sample neural music tracks:
- 3 Focus tracks (Deep Focus Flow, Concentration Boost, Alpha Waves)
- 3 Relax tracks (Ocean Breeze, Forest Meditation, Peaceful Mind)
- 3 Deep Sleep tracks (Delta Dreams, Night Whispers, Theta Healing)

## Usage

### Page 1: Categories
- Browse three music categories with beautiful gradient cards
- Tap any category to view available tracks
- Each track shows duration and can be saved to favorites
- Tap a track to select it and navigate to the player

### Page 2: Player
- View currently selected track information
- Choose between Infinite and Timing playback modes
- For Timing mode, select duration from 15-120 minutes
- Watch real-time countdown in timing mode
- Control playback with play/pause/stop buttons
- Save tracks to favorites with heart button

### Page 3: Saved Music
- View all saved favorite tracks
- Organized list with category indicators
- Tap any track to play it immediately
- Swipe to delete tracks from saved collection
- Visual indicators show currently playing track

## Customization

### Adding New Categories
1. Add new case to `MusicCategory` enum
2. Define icon, color, and description
3. Add sample tracks with the new category

### Adding New Tracks
1. Add `MusicTrack` instances to `sampleTracks` array
2. Specify category, duration, and audio URL
3. Tracks automatically appear in category views

### Styling
- Colors defined in `MusicCategory` enum
- SwiftUI modifiers for consistent styling
- Gradient backgrounds and shadows for visual appeal

## Future Enhancements

- [ ] Real audio file integration
- [ ] Cloud sync for saved tracks
- [ ] Custom timer durations
- [ ] Sleep timer with fade-out
- [ ] Offline download capability
- [ ] User-created playlists
- [ ] Background app refresh
- [ ] Widget support
- [ ] Apple Watch companion app

## License

This project is created for educational and demonstration purposes.
