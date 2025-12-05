import Foundation
import AVFoundation
import Combine

enum PlaybackMode {
    case infinite
    case timing(minutes: Int)
}

class AudioManager: ObservableObject {
    @Published var currentTrack: MusicTrack?
    @Published var isPlaying = false
    @Published var playbackMode: PlaybackMode = .infinite
    @Published var currentTime: TimeInterval = 0
    @Published var remainingTime: TimeInterval = 0
    @Published var savedTracks: Set<MusicTrack> = []
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var playbackTimer: Timer?
    
    init() {
        setupAudioSession()
        loadSavedTracks()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func selectTrack(_ track: MusicTrack) {
        currentTrack = track
        loadTrack(track)
    }
    
    private func loadTrack(_ track: MusicTrack) {
        guard let url = URL(string: track.audioURL) else {
            print("Invalid audio URL")
            return
        }
        
        // For demo purposes, we'll use a local sound or simulate playback
        // In a real app, you'd download or stream the audio
        do {
            // Create a simple tone for demo
            let audioData = createDemoAudioData()
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.numberOfLoops = playbackMode == .infinite ? -1 : 0
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to load audio: \(error)")
        }
    }
    
    private func createDemoAudioData() -> Data {
        // Create a simple sine wave for demo purposes
        let sampleRate: Double = 44100
        let frequency: Double = 440 // A4 note
        let duration: Double = 2.0
        let amplitude: Double = 0.3
        
        let frameCount = Int(sampleRate * duration)
        var samples: [Float] = []
        
        for i in 0..<frameCount {
            let sample = Float(amplitude * sin(2.0 * Double.pi * frequency * Double(i) / sampleRate))
            samples.append(sample)
        }
        
        return Data(bytes: samples, count: samples.count * MemoryLayout<Float>.size)
    }
    
    func play() {
        guard let player = audioPlayer else { return }
        
        player.play()
        isPlaying = true
        startTimer()
        
        if case .timing(let minutes) = playbackMode {
            remainingTime = TimeInterval(minutes * 60)
            startPlaybackTimer()
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
        stopPlaybackTimer()
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
        currentTime = 0
        remainingTime = 0
        stopTimer()
        stopPlaybackTimer()
    }
    
    func setPlaybackMode(_ mode: PlaybackMode) {
        playbackMode = mode
        
        if let player = audioPlayer {
            switch mode {
            case .infinite:
                player.numberOfLoops = -1
                remainingTime = 0
                stopPlaybackTimer()
            case .timing(let minutes):
                player.numberOfLoops = 0
                remainingTime = TimeInterval(minutes * 60)
                if isPlaying {
                    startPlaybackTimer()
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startPlaybackTimer() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stop()
            }
        }
    }
    
    private func stopPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    func toggleSaved(_ track: MusicTrack) {
        if savedTracks.contains(track) {
            savedTracks.remove(track)
        } else {
            savedTracks.insert(track)
        }
        saveTracks()
    }
    
    private func loadSavedTracks() {
        // In a real app, you'd load from UserDefaults or Core Data
        // For demo, we'll start with empty set
    }
    
    private func saveTracks() {
        // In a real app, you'd save to UserDefaults or Core Data
        // For demo, we'll just keep in memory
    }
    
    var formattedCurrentTime: String {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var formattedRemainingTime: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}