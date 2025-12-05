import SwiftUI

struct SavedMusicView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        NavigationView {
            VStack {
                if audioManager.savedTracks.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "heart")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        
                        Text("No Saved Music")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text("Tap the heart icon on any track to save it here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Saved Tracks List
                    List {
                        ForEach(Array(audioManager.savedTracks), id: \.id) { track in
                            SavedTrackRow(track: track) {
                                audioManager.selectTrack(track)
                            }
                        }
                        .onDelete(perform: deleteTracks)
                    }
                }
            }
            .navigationTitle("Saved Music")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !audioManager.savedTracks.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }
    
    private func deleteTracks(offsets: IndexSet) {
        let tracksArray = Array(audioManager.savedTracks)
        for index in offsets {
            let track = tracksArray[index]
            audioManager.toggleSaved(track)
        }
    }
}

struct SavedTrackRow: View {
    let track: MusicTrack
    let action: () -> Void
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Category Color Indicator
                Rectangle()
                    .fill(Color(track.category.color))
                    .frame(width: 4)
                    .cornerRadius(2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(track.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(track.category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(track.category.color).opacity(0.2))
                            .foregroundColor(Color(track.category.color))
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        Text(track.formattedDuration)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Play indicator if this is the current track
                if audioManager.currentTrack == track {
                    VStack {
                        Image(systemName: audioManager.isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        if audioManager.isPlaying {
                            Text("Playing")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SavedMusicView()
        .environmentObject(AudioManager())
}