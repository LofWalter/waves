import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CategoriesView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Categories")
                }
                .tag(0)
            
            PlayerView()
                .tabItem {
                    Image(systemName: "play.circle")
                    Text("Player")
                }
                .tag(1)
            
            SavedMusicView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Saved")
                }
                .tag(2)
        }
        .environmentObject(audioManager)
        .accentColor(.blue)
    }
}