#!/usr/bin/env python3

"""
Neural Waves App - UI Structure Validation
This script validates the SwiftUI code structure and components
"""

import os
import re
from pathlib import Path

print("🎨 Neural Waves App - UI Structure Validation")
print("=" * 50)

def read_file(file_path):
    """Read file content safely"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"❌ Error reading {file_path}: {e}")
        return None

def validate_swift_file(file_path, expected_components):
    """Validate a Swift file contains expected components"""
    content = read_file(file_path)
    if not content:
        return False
    
    print(f"\n📄 Validating {os.path.basename(file_path)}...")
    
    all_found = True
    for component in expected_components:
        if component in content:
            print(f"  ✓ Found: {component}")
        else:
            print(f"  ❌ Missing: {component}")
            all_found = False
    
    return all_found

def validate_project_structure():
    """Validate the overall project structure"""
    print("\n📁 Validating Project Structure...")
    
    base_path = Path(".")
    required_files = [
        "NeuralWaves.xcodeproj/project.pbxproj",
        "NeuralWaves/NeuralWavesApp.swift",
        "NeuralWaves/ContentView.swift",
        "NeuralWaves/Models/MusicCategory.swift",
        "NeuralWaves/Models/MusicTrack.swift",
        "NeuralWaves/Views/CategoriesView.swift",
        "NeuralWaves/Views/PlayerView.swift",
        "NeuralWaves/Views/SavedMusicView.swift",
        "NeuralWaves/Managers/AudioManager.swift",
        "NeuralWaves/Assets.xcassets/Contents.json",
        ".gitignore"
    ]
    
    all_exist = True
    for file_path in required_files:
        full_path = base_path / file_path
        if full_path.exists():
            print(f"  ✓ {file_path}")
        else:
            print(f"  ❌ Missing: {file_path}")
            all_exist = False
    
    return all_exist

def validate_app_entry_point():
    """Validate the main app entry point"""
    return validate_swift_file("NeuralWaves/NeuralWavesApp.swift", [
        "@main",
        "struct NeuralWavesApp: App",
        "WindowGroup",
        "ContentView()"
    ])

def validate_content_view():
    """Validate the main content view"""
    return validate_swift_file("NeuralWaves/ContentView.swift", [
        "struct ContentView: View",
        "TabView",
        "CategoriesView()",
        "PlayerView()",
        "SavedMusicView()",
        "@StateObject private var audioManager",
        ".environmentObject(audioManager)"
    ])

def validate_categories_view():
    """Validate Page 1: Categories View"""
    return validate_swift_file("NeuralWaves/Views/CategoriesView.swift", [
        "struct CategoriesView: View",
        "NavigationView",
        "LazyVGrid",
        "MusicCategory.allCases",
        "CategoryCard",
        "CategoryDetailView",
        "@EnvironmentObject var audioManager",
        ".sheet(item: $selectedCategory)"
    ])

def validate_player_view():
    """Validate Page 2: Player View"""
    return validate_swift_file("NeuralWaves/Views/PlayerView.swift", [
        "struct PlayerView: View",
        "NavigationView",
        "@EnvironmentObject var audioManager",
        "PlaybackMode",
        "audioManager.play()",
        "audioManager.pause()",
        "audioManager.stop()",
        "formattedCurrentTime",
        "formattedRemainingTime",
        "Picker(\"Duration\""
    ])

def validate_saved_music_view():
    """Validate Page 3: Saved Music View"""
    return validate_swift_file("NeuralWaves/Views/SavedMusicView.swift", [
        "struct SavedMusicView: View",
        "NavigationView",
        "audioManager.savedTracks",
        "SavedTrackRow",
        "onDelete(perform: deleteTracks)",
        "EditButton()",
        "@EnvironmentObject var audioManager"
    ])

def validate_music_category_model():
    """Validate MusicCategory model"""
    return validate_swift_file("NeuralWaves/Models/MusicCategory.swift", [
        "enum MusicCategory",
        "case focus",
        "case relax",
        "case deepSleep",
        "var description: String",
        "var iconName: String",
        "var color: String",
        "CaseIterable",
        "Identifiable"
    ])

def validate_music_track_model():
    """Validate MusicTrack model"""
    return validate_swift_file("NeuralWaves/Models/MusicTrack.swift", [
        "struct MusicTrack",
        "let title: String",
        "let artist: String",
        "let category: MusicCategory",
        "let duration: TimeInterval",
        "var formattedDuration: String",
        "static let sampleTracks",
        "Identifiable",
        "Codable",
        "Equatable"
    ])

def validate_audio_manager():
    """Validate AudioManager"""
    return validate_swift_file("NeuralWaves/Managers/AudioManager.swift", [
        "class AudioManager: ObservableObject",
        "@Published var currentTrack",
        "@Published var isPlaying",
        "@Published var playbackMode",
        "@Published var savedTracks",
        "func selectTrack",
        "func play()",
        "func pause()",
        "func stop()",
        "func setPlaybackMode",
        "func toggleSaved",
        "AVAudioPlayer",
        "PlaybackMode"
    ])

def validate_sample_data():
    """Validate sample data completeness"""
    print("\n🎵 Validating Sample Data...")
    
    content = read_file("NeuralWaves/Models/MusicTrack.swift")
    if not content:
        return False
    
    # Count tracks per category
    focus_count = content.count('category: .focus')
    relax_count = content.count('category: .relax')
    sleep_count = content.count('category: .deepSleep')
    
    print(f"  ✓ Focus tracks: {focus_count}")
    print(f"  ✓ Relax tracks: {relax_count}")
    print(f"  ✓ Deep Sleep tracks: {sleep_count}")
    
    if focus_count == 3 and relax_count == 3 and sleep_count == 3:
        print("  ✓ All categories have 3 tracks each")
        return True
    else:
        print("  ❌ Incorrect track distribution")
        return False

def validate_ui_components():
    """Validate UI components and interactions"""
    print("\n🎨 Validating UI Components...")
    
    # Check for proper SwiftUI patterns
    categories_content = read_file("NeuralWaves/Views/CategoriesView.swift")
    player_content = read_file("NeuralWaves/Views/PlayerView.swift")
    saved_content = read_file("NeuralWaves/Views/SavedMusicView.swift")
    
    ui_checks = [
        ("Button actions", "Button(action:" in categories_content),
        ("State management", "@State" in player_content),
        ("Environment objects", "@EnvironmentObject" in saved_content),
        ("Navigation", "NavigationView" in categories_content),
        ("Lists", "List" in saved_content),
        ("Grids", "LazyVGrid" in categories_content),
        ("Sheets", ".sheet(" in categories_content),
        ("Tab items", ".tabItem" in read_file("NeuralWaves/ContentView.swift")),
    ]
    
    all_passed = True
    for check_name, condition in ui_checks:
        if condition:
            print(f"  ✓ {check_name}")
        else:
            print(f"  ❌ {check_name}")
            all_passed = False
    
    return all_passed

def validate_accessibility():
    """Validate accessibility considerations"""
    print("\n♿ Validating Accessibility...")
    
    # Check for accessibility-friendly patterns
    all_files = [
        "NeuralWaves/Views/CategoriesView.swift",
        "NeuralWaves/Views/PlayerView.swift",
        "NeuralWaves/Views/SavedMusicView.swift"
    ]
    
    accessibility_checks = []
    for file_path in all_files:
        content = read_file(file_path)
        if content:
            # Check for proper text labels
            has_text_labels = "Text(" in content
            # Check for SF Symbols usage
            has_sf_symbols = "systemName:" in content
            # Check for semantic structure
            has_vstack_hstack = "VStack" in content and "HStack" in content
            
            accessibility_checks.append((os.path.basename(file_path), has_text_labels and has_sf_symbols and has_vstack_hstack))
    
    all_accessible = True
    for file_name, is_accessible in accessibility_checks:
        if is_accessible:
            print(f"  ✓ {file_name} has accessibility-friendly structure")
        else:
            print(f"  ⚠️ {file_name} may need accessibility improvements")
            all_accessible = False
    
    return all_accessible

def run_ui_validation():
    """Run all UI validation tests"""
    print("Starting UI structure validation...\n")
    
    tests = [
        ("Project Structure", validate_project_structure),
        ("App Entry Point", validate_app_entry_point),
        ("Content View", validate_content_view),
        ("Categories View (Page 1)", validate_categories_view),
        ("Player View (Page 2)", validate_player_view),
        ("Saved Music View (Page 3)", validate_saved_music_view),
        ("MusicCategory Model", validate_music_category_model),
        ("MusicTrack Model", validate_music_track_model),
        ("Audio Manager", validate_audio_manager),
        ("Sample Data", validate_sample_data),
        ("UI Components", validate_ui_components),
        ("Accessibility", validate_accessibility),
    ]
    
    passed_tests = 0
    total_tests = len(tests)
    
    for test_name, test_func in tests:
        print(f"\n🧪 Testing: {test_name}")
        try:
            if test_func():
                print(f"✅ {test_name}: PASSED")
                passed_tests += 1
            else:
                print(f"❌ {test_name}: FAILED")
        except Exception as e:
            print(f"💥 {test_name}: ERROR - {e}")
    
    print(f"\n📊 UI Validation Summary:")
    print(f"  Passed: {passed_tests}/{total_tests}")
    print(f"  Success Rate: {(passed_tests/total_tests)*100:.1f}%")
    
    if passed_tests == total_tests:
        print("\n🎉 All UI validation tests passed!")
        print("✅ Neural Waves app UI structure is complete and well-formed")
        return True
    else:
        print(f"\n⚠️ {total_tests - passed_tests} tests failed")
        print("❌ Some UI components need attention")
        return False

if __name__ == "__main__":
    success = run_ui_validation()
    exit(0 if success else 1)