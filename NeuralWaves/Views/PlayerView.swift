import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var selectedTimingMinutes = 30
    
    private let timingOptions = [15, 30, 45, 60, 90, 120]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                if let track = audioManager.currentTrack {
                    // Track Info
                    VStack(spacing: 12) {
                        Text(track.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(track.artist)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(track.category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(track.category.color).opacity(0.2))
                            .foregroundColor(Color(track.category.color))
                            .cornerRadius(8)
                    }
                    .padding(.top)
                    
                    // Time Display
                    VStack(spacing: 8) {
                        if case .timing(_) = audioManager.playbackMode {
                            Text("Remaining Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(audioManager.formattedRemainingTime)
                                .font(.system(size: 48, weight: .light, design: .monospaced))
                                .foregroundColor(.primary)
                        } else {
                            Text("Playing Time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(audioManager.formattedCurrentTime)
                                .font(.system(size: 48, weight: .light, design: .monospaced))
                                .foregroundColor(.primary)
                        }
                    }
                    .frame(height: 100)
                    
                    // Playback Mode Selection
                    VStack(spacing: 16) {
                        Text("Playback Mode")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                audioManager.setPlaybackMode(.infinite)
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "infinity")
                                        .font(.title2)
                                    Text("Infinite")
                                        .font(.caption)
                                }
                                .foregroundColor(
                                    audioManager.playbackMode == .infinite ? .white : .primary
                                )
                                .frame(width: 80, height: 60)
                                .background(
                                    audioManager.playbackMode == .infinite ? 
                                    Color.blue : Color.gray.opacity(0.2)
                                )
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                audioManager.setPlaybackMode(.timing(minutes: selectedTimingMinutes))
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "timer")
                                        .font(.title2)
                                    Text("Timing")
                                        .font(.caption)
                                }
                                .foregroundColor(
                                    case .timing(_) = audioManager.playbackMode ? .white : .primary
                                )
                                .frame(width: 80, height: 60)
                                .background(
                                    case .timing(_) = audioManager.playbackMode ? 
                                    Color.blue : Color.gray.opacity(0.2)
                                )
                                .cornerRadius(12)
                            }
                        }
                        
                        // Timing Duration Picker
                        if case .timing(_) = audioManager.playbackMode {
                            VStack(spacing: 8) {
                                Text("Duration (minutes)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Picker("Duration", selection: $selectedTimingMinutes) {
                                    ForEach(timingOptions, id: \.self) { minutes in
                                        Text("\(minutes) min").tag(minutes)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .onChange(of: selectedTimingMinutes) { newValue in
                                    audioManager.setPlaybackMode(.timing(minutes: newValue))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Playback Controls
                    HStack(spacing: 40) {
                        Button(action: {
                            audioManager.stop()
                        }) {
                            Image(systemName: "stop.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .disabled(!audioManager.isPlaying)
                        
                        Button(action: {
                            if audioManager.isPlaying {
                                audioManager.pause()
                            } else {
                                audioManager.play()
                            }
                        }) {
                            Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            audioManager.toggleSaved(track)
                        }) {
                            Image(systemName: audioManager.savedTracks.contains(track) ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(audioManager.savedTracks.contains(track) ? .red : .gray)
                        }
                    }
                    .padding(.bottom, 40)
                    
                } else {
                    // No Track Selected State
                    VStack(spacing: 20) {
                        Image(systemName: "music.note")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        
                        Text("No Track Selected")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text("Go to Categories to select a neural music track")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .navigationTitle("Player")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PlayerView()
        .environmentObject(AudioManager())
}