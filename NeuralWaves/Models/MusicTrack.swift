import Foundation

struct MusicTrack: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let artist: String
    let category: MusicCategory
    let duration: TimeInterval
    let audioURL: String
    let imageURL: String?
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    static func == (lhs: MusicTrack, rhs: MusicTrack) -> Bool {
        lhs.id == rhs.id
    }
}

extension MusicTrack {
    static let sampleTracks: [MusicTrack] = [
        // Focus tracks
        MusicTrack(
            title: "Deep Focus Flow",
            artist: "Neural Waves",
            category: .focus,
            duration: 1800, // 30 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        MusicTrack(
            title: "Concentration Boost",
            artist: "Mind Sync",
            category: .focus,
            duration: 2400, // 40 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        MusicTrack(
            title: "Alpha Waves",
            artist: "Brain Tune",
            category: .focus,
            duration: 3600, // 60 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        
        // Relax tracks
        MusicTrack(
            title: "Ocean Breeze",
            artist: "Calm Sounds",
            category: .relax,
            duration: 1200, // 20 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        MusicTrack(
            title: "Forest Meditation",
            artist: "Nature Harmony",
            category: .relax,
            duration: 1800, // 30 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        MusicTrack(
            title: "Peaceful Mind",
            artist: "Zen Master",
            category: .relax,
            duration: 2700, // 45 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        
        // Deep Sleep tracks
        MusicTrack(
            title: "Delta Dreams",
            artist: "Sleep Lab",
            category: .deepSleep,
            duration: 3600, // 60 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        MusicTrack(
            title: "Night Whispers",
            artist: "Dream Weaver",
            category: .deepSleep,
            duration: 4800, // 80 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        ),
        MusicTrack(
            title: "Theta Healing",
            artist: "Sleep Therapy",
            category: .deepSleep,
            duration: 5400, // 90 minutes
            audioURL: "https://www.soundjay.com/misc/sounds/bell-ringing-05.wav",
            imageURL: nil
        )
    ]
}