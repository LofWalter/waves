import XCTest
@testable import NeuralWaves

final class NeuralWavesTests: XCTestCase {
    
    var audioManager: AudioManager!
    
    override func setUpWithError() throws {
        audioManager = AudioManager()
    }
    
    override func tearDownWithError() throws {
        audioManager = nil
    }
    
    // MARK: - Data Model Tests
    
    func testMusicCategoryProperties() throws {
        // Test Focus category
        XCTAssertEqual(MusicCategory.focus.rawValue, "Focus")
        XCTAssertEqual(MusicCategory.focus.description, "Enhance concentration and productivity")
        XCTAssertEqual(MusicCategory.focus.iconName, "brain.head.profile")
        XCTAssertEqual(MusicCategory.focus.color, "blue")
        
        // Test Relax category
        XCTAssertEqual(MusicCategory.relax.rawValue, "Relax")
        XCTAssertEqual(MusicCategory.relax.description, "Unwind and reduce stress")
        XCTAssertEqual(MusicCategory.relax.iconName, "leaf.fill")
        XCTAssertEqual(MusicCategory.relax.color, "green")
        
        // Test Deep Sleep category
        XCTAssertEqual(MusicCategory.deepSleep.rawValue, "Deep Sleep")
        XCTAssertEqual(MusicCategory.deepSleep.description, "Promote restful sleep")
        XCTAssertEqual(MusicCategory.deepSleep.iconName, "moon.fill")
        XCTAssertEqual(MusicCategory.deepSleep.color, "purple")
    }
    
    func testMusicTrackSampleData() throws {
        let sampleTracks = MusicTrack.sampleTracks
        
        // Test we have 9 sample tracks
        XCTAssertEqual(sampleTracks.count, 9)
        
        // Test we have 3 tracks per category
        let focusTracks = sampleTracks.filter { $0.category == .focus }
        let relaxTracks = sampleTracks.filter { $0.category == .relax }
        let sleepTracks = sampleTracks.filter { $0.category == .deepSleep }
        
        XCTAssertEqual(focusTracks.count, 3)
        XCTAssertEqual(relaxTracks.count, 3)
        XCTAssertEqual(sleepTracks.count, 3)
        
        // Test track properties
        let firstTrack = sampleTracks.first!
        XCTAssertFalse(firstTrack.title.isEmpty)
        XCTAssertFalse(firstTrack.artist.isEmpty)
        XCTAssertGreaterThan(firstTrack.duration, 0)
        XCTAssertFalse(firstTrack.audioURL.isEmpty)
    }
    
    func testMusicTrackFormattedDuration() throws {
        let track = MusicTrack(
            title: "Test Track",
            artist: "Test Artist",
            category: .focus,
            duration: 1830, // 30 minutes 30 seconds
            audioURL: "test.mp3",
            imageURL: nil
        )
        
        XCTAssertEqual(track.formattedDuration, "30:30")
    }
    
    // MARK: - Audio Manager Tests
    
    func testAudioManagerInitialization() throws {
        XCTAssertNil(audioManager.currentTrack)
        XCTAssertFalse(audioManager.isPlaying)
        XCTAssertEqual(audioManager.currentTime, 0)
        XCTAssertEqual(audioManager.remainingTime, 0)
        XCTAssertTrue(audioManager.savedTracks.isEmpty)
        
        // Test default playback mode
        if case .infinite = audioManager.playbackMode {
            // Success - default is infinite
        } else {
            XCTFail("Default playback mode should be infinite")
        }
    }
    
    func testTrackSelection() throws {
        let testTrack = MusicTrack.sampleTracks.first!
        
        audioManager.selectTrack(testTrack)
        
        XCTAssertEqual(audioManager.currentTrack, testTrack)
    }
    
    func testPlaybackModeChanges() throws {
        // Test setting infinite mode
        audioManager.setPlaybackMode(.infinite)
        if case .infinite = audioManager.playbackMode {
            // Success
        } else {
            XCTFail("Playback mode should be infinite")
        }
        
        // Test setting timing mode
        audioManager.setPlaybackMode(.timing(minutes: 30))
        if case .timing(let minutes) = audioManager.playbackMode {
            XCTAssertEqual(minutes, 30)
        } else {
            XCTFail("Playback mode should be timing with 30 minutes")
        }
    }
    
    func testSavedTracksManagement() throws {
        let testTrack = MusicTrack.sampleTracks.first!
        
        // Initially empty
        XCTAssertTrue(audioManager.savedTracks.isEmpty)
        XCTAssertFalse(audioManager.savedTracks.contains(testTrack))
        
        // Add track
        audioManager.toggleSaved(testTrack)
        XCTAssertTrue(audioManager.savedTracks.contains(testTrack))
        XCTAssertEqual(audioManager.savedTracks.count, 1)
        
        // Remove track
        audioManager.toggleSaved(testTrack)
        XCTAssertFalse(audioManager.savedTracks.contains(testTrack))
        XCTAssertTrue(audioManager.savedTracks.isEmpty)
    }
    
    func testTimeFormatting() throws {
        audioManager.currentTime = 125 // 2:05
        XCTAssertEqual(audioManager.formattedCurrentTime, "2:05")
        
        audioManager.remainingTime = 3661 // 61:01
        XCTAssertEqual(audioManager.formattedRemainingTime, "61:01")
    }
    
    // MARK: - Integration Tests
    
    func testCompleteUserFlow() throws {
        // 1. Select a track from categories
        let focusTrack = MusicTrack.sampleTracks.filter { $0.category == .focus }.first!
        audioManager.selectTrack(focusTrack)
        XCTAssertEqual(audioManager.currentTrack, focusTrack)
        
        // 2. Set timing mode
        audioManager.setPlaybackMode(.timing(minutes: 45))
        if case .timing(let minutes) = audioManager.playbackMode {
            XCTAssertEqual(minutes, 45)
        } else {
            XCTFail("Should be in timing mode")
        }
        
        // 3. Save the track
        audioManager.toggleSaved(focusTrack)
        XCTAssertTrue(audioManager.savedTracks.contains(focusTrack))
        
        // 4. Switch to infinite mode
        audioManager.setPlaybackMode(.infinite)
        if case .infinite = audioManager.playbackMode {
            // Success
        } else {
            XCTFail("Should be in infinite mode")
        }
        
        // 5. Verify saved track persists
        XCTAssertTrue(audioManager.savedTracks.contains(focusTrack))
    }
    
    func testMultipleSavedTracks() throws {
        let focusTrack = MusicTrack.sampleTracks.filter { $0.category == .focus }.first!
        let relaxTrack = MusicTrack.sampleTracks.filter { $0.category == .relax }.first!
        let sleepTrack = MusicTrack.sampleTracks.filter { $0.category == .deepSleep }.first!
        
        // Save multiple tracks
        audioManager.toggleSaved(focusTrack)
        audioManager.toggleSaved(relaxTrack)
        audioManager.toggleSaved(sleepTrack)
        
        XCTAssertEqual(audioManager.savedTracks.count, 3)
        XCTAssertTrue(audioManager.savedTracks.contains(focusTrack))
        XCTAssertTrue(audioManager.savedTracks.contains(relaxTrack))
        XCTAssertTrue(audioManager.savedTracks.contains(sleepTrack))
        
        // Remove one track
        audioManager.toggleSaved(relaxTrack)
        XCTAssertEqual(audioManager.savedTracks.count, 2)
        XCTAssertFalse(audioManager.savedTracks.contains(relaxTrack))
    }
    
    // MARK: - Performance Tests
    
    func testTrackFilteringPerformance() throws {
        measure {
            for category in MusicCategory.allCases {
                let _ = MusicTrack.sampleTracks.filter { $0.category == category }
            }
        }
    }
    
    func testSavedTracksPerformance() throws {
        let tracks = MusicTrack.sampleTracks
        
        measure {
            for track in tracks {
                audioManager.toggleSaved(track)
            }
            for track in tracks {
                audioManager.toggleSaved(track)
            }
        }
    }
}